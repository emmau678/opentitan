# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//rules:rv.bzl", "rv_rule")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cc_toolchain")

def _get_assembler(cc_toolchain):
    """Find the path to riscv-unknown-elf-as."""

    # Note: the toolchain config doesn"t appear to have a good way to get
    # access to the assembler.  We should be able to access it via the
    # the compiler, but I had trouble with //hw/ip/otbn/util/otbn_as.py invoking
    # the compiler as assembler.
    return [f for f in cc_toolchain.all_files.to_list() if f.basename.endswith("as")][0]

def _otbn_assemble_sources(ctx):
    """Helper function that, for each source file in the provided context, adds
    an action to the context that invokes the otbn assember (otbn_as.py),
    producing a corresponding object file. Returns a list of all object files
    that will be generated by these actions.
    """
    cc_toolchain = find_cc_toolchain(ctx).cc
    assembler = _get_assembler(cc_toolchain)

    objs = []
    for src in ctx.files.srcs:
        obj = ctx.actions.declare_file(src.basename.replace("." + src.extension, ".o"))
        objs.append(obj)
        ctx.actions.run(
            outputs = [obj],
            inputs = ([src] +
                      cc_toolchain.all_files.to_list() +
                      [ctx.executable._otbn_as]),
            env = {
                "RV32_TOOL_AS": assembler.path,
            },
            arguments = ["-o", obj.path, src.path],
            executable = ctx.executable._otbn_as,
        )

    return objs

def _otbn_library(ctx):
    """Produces a collection of object files, one per source file, that can be
    used as a dependency for otbn binaries."""
    objs = _otbn_assemble_sources(ctx)

    return [
        DefaultInfo(
            files = depset(objs),
            data_runfiles = ctx.runfiles(files = objs),
        ),
    ]

def _otbn_binary(ctx):
    """The build process for otbn resources currently invokes
    `//hw/ip/otbn/util/otbn_{as,ld,...}.py` to build the otbn resource.
    These programs are python scripts which translate otbn special
    instructions into the proper opcode sequences and _then_ invoke the normal
    `rv32-{as,ld,...}` programs to produce the resource.  These "native"
    otbn resources are the `otbn_objs` and `elf` output groups.

    In order to make the otbn resource useful to the the main CPU, the
    otbn resource needs to be included as a blob of data that the main
    CPU can dump into the otbn `imem` area and ask otbn to execute it.
    `util/otbn-build.py` does this with some objcopy-fu, emitting
    `foo.rv32embed.o`.  Bazel's `cc_*` rules really want dependency objects
    expressed as archives rather than raw object files, so I've modified
    `otbn-build` to also emit an archive file.

    _Morally_, the otbn resource is a data dependency.  However the
    practical meaning of a `data` dependency in bazel is a file made
    available at runtime, which is not how we're using the otbn resource.
    The closest analog is something like `cc_embed_data`, which is like
    a data dependency that needs to be linked into the main program.
    We achieve by having `otbn_build.py` emit a conventional RV32I library
    that other rules can depend on in their `deps`.
    """
    cc_toolchain = find_cc_toolchain(ctx).cc
    assembler = _get_assembler(cc_toolchain)

    # Run the otbn assembler on source files to produce object (.o) files.
    objs = _otbn_assemble_sources(ctx)

    # Declare output files.
    elf = ctx.actions.declare_file(ctx.attr.name + ".elf")
    rv32embed = ctx.actions.declare_file(ctx.attr.name + ".rv32embed.o")
    archive = ctx.actions.declare_file(ctx.attr.name + ".rv32embed.a")

    deps = [f for dep in ctx.attr.deps for f in dep.files.to_list()]

    # Run the otbn_build.py script to link object files from the sources and
    # dependencies.
    ctx.actions.run(
        outputs = [elf, rv32embed, archive],
        inputs = (objs +
                  deps +
                  cc_toolchain.all_files.to_list() +
                  ctx.files._otbn_data +
                  [ctx.executable._wrapper]),
        env = {
            "RV32_TOOL_AS": assembler.path,
            "RV32_TOOL_AR": cc_toolchain.ar_executable,
            "RV32_TOOL_LD": cc_toolchain.ld_executable,
            "RV32_TOOL_OBJCOPY": cc_toolchain.objcopy_executable,
        },
        arguments = [
            "--app-name={}".format(ctx.attr.name),
            "--archive",
            "--no-assembler",
            "--out-dir={}".format(elf.dirname),
        ] + [obj.path for obj in (objs + deps)],
        executable = ctx.executable._wrapper,
    )

    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    outputs = objs + [elf, rv32embed, archive]
    return [
        DefaultInfo(files = depset(outputs), data_runfiles = ctx.runfiles(files = outputs)),
        OutputGroupInfo(
            otbn_objs = depset(objs + deps),
            elf = depset([elf]),
            rv32embed = depset([rv32embed]),
            archive = depset([archive]),
        ),
        # Emit a CcInfo provider so that this rule can be a dependency in other
        # cc_* rules.
        CcInfo(
            linking_context = cc_common.create_linking_context(
                linker_inputs = depset([cc_common.create_linker_input(
                    owner = ctx.label,
                    libraries = depset([cc_common.create_library_to_link(
                        actions = ctx.actions,
                        feature_configuration = feature_configuration,
                        cc_toolchain = cc_toolchain,
                        static_library = archive,
                    )]),
                )]),
            ),
        ),
    ]

def _otbn_sim_test(ctx):
    """This rule is for standalone OTBN unit tests, which are run on the host
    via the OTBN simulator.

    It first generates binaries using the same method as otbn_binary, then runs
    them on the simulator. Tests are expected to count failures in the w0
    register; the test checks that w0=0 to determine if the test passed.
    """
    providers = _otbn_binary(ctx)

    # Extract the output .elf file from the output group.
    elf = providers[1].elf.to_list()[0]

    # Create a file with expected values (always w0=0).
    # TODO: update existing tests to include expected-value files.
    exp_file = ctx.actions.declare_file("{}.exp".format(ctx.label.name))
    ctx.actions.write(
        output = exp_file,
        content = "w0 = 0\n",
    )

    # Create a simple script that runs the OTBN test wrapper on the .elf file
    # using the provided simulator path.
    sim_test_wrapper = ctx.executable._sim_test_wrapper
    simulator = ctx.executable._simulator
    ctx.actions.write(
        output = ctx.outputs.executable,
        content = "{} {} {} {}".format(sim_test_wrapper.short_path, simulator.short_path, exp_file.short_path, elf.short_path),
    )

    # Runfiles include sources, the .elf file, the simulator and test wrapper
    # themselves, and all the simulator and test wrapper runfiles.
    runfiles = ctx.runfiles(files = (ctx.files.srcs + [elf, exp_file, ctx.executable._simulator, ctx.executable._sim_test_wrapper]))
    runfiles = runfiles.merge(ctx.attr._simulator[DefaultInfo].default_runfiles)
    runfiles = runfiles.merge(ctx.attr._sim_test_wrapper[DefaultInfo].default_runfiles)
    return [
        DefaultInfo(runfiles = runfiles),
        providers[1],
    ]

def _otbn_consttime_test_impl(ctx):
    """This rule checks if a program or subroutine is constant-time.

    There are some limitations to this check; see the Python script's
    documentation for details. In particular, the check may not be able to
    determine that a program runs in constant-time when in fact it does.
    However, if the check passes, the program should always run in constant
    time; that is, the check can produce false negatives but never false
    positives.

    This rule expects one dependency of an otbn_binary or otbn_sim_test type,
    which should provide exactly one `.elf` file.
    """

    # Extract the output .elf file from the output group.
    elf = [f for t in ctx.attr.deps for f in t[OutputGroupInfo].elf.to_list()]
    if len(elf) != 1:
        fail("Expected only one .elf file in dependencies, got: " + str(elf))
    elf = elf[0]

    # Write a very simple script that runs the checker.
    script_content = "{} {} --verbose".format(ctx.executable._checker.short_path, elf.short_path)
    if ctx.attr.subroutine:
        script_content += " --subroutine {}".format(ctx.attr.subroutine)
    if ctx.attr.secrets:
        script_content += " --secrets {}".format(" ".join(ctx.attr.secrets))
    if ctx.attr.initial_constants:
        script_content += " --constants {}".format(" ".join(ctx.attr.initial_constants))
    ctx.actions.write(
        output = ctx.outputs.executable,
        content = script_content,
    )

    # The .elf file must be added to runfiles in order to be visible to the
    # test at runtime. In addition, we need to add all the runfiles from the
    # checker script itself (e.g. the Python runtime and dependencies).
    runfiles = ctx.runfiles(files = [elf])
    runfiles = runfiles.merge(ctx.attr._checker[DefaultInfo].default_runfiles)
    return [DefaultInfo(runfiles = runfiles)]

def _otbn_insn_count_range(ctx):
    """This rule gets min/max possible instruction counts for an OTBN program.
    """

    # Extract the .elf file to check from the dependency list.
    elf = [f for t in ctx.attr.deps for f in t[OutputGroupInfo].elf.to_list()]
    if len(elf) != 1:
        fail("Expected only one .elf file in dependencies, got: " + str(elf))
    elf = elf[0]

    # Command to run the counter script and extract the min/max values.
    out = ctx.actions.declare_file(ctx.attr.name + ".txt")
    ctx.actions.run_shell(
        outputs = [out],
        inputs = [ctx.file._counter, elf],
        command = "{} {} > {}".format(ctx.file._counter.path, elf.path, out.path),
    )

    runfiles = ctx.runfiles(files = ([out]))
    return [DefaultInfo(files = depset([out]), runfiles = runfiles)]

otbn_library = rv_rule(
    implementation = _otbn_library,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
        "_otbn_as": attr.label(
            default = "//hw/ip/otbn/util:otbn_as",
            executable = True,
            cfg = "exec",
        ),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
    incompatible_use_toolchain_transition = True,
)

otbn_binary = rv_rule(
    implementation = _otbn_binary,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [DefaultInfo]),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "_otbn_as": attr.label(
            default = "//hw/ip/otbn/util:otbn_as",
            executable = True,
            cfg = "exec",
        ),
        "_otbn_data": attr.label(
            default = "//hw/ip/otbn/data:all_files",
            allow_files = True,
        ),
        "_wrapper": attr.label(
            default = "//util:otbn_build",
            executable = True,
            cfg = "exec",
        ),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
    incompatible_use_toolchain_transition = True,
)

otbn_sim_test = rv_rule(
    implementation = _otbn_sim_test,
    test = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [DefaultInfo]),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "_otbn_as": attr.label(
            default = "//hw/ip/otbn/util:otbn_as",
            executable = True,
            cfg = "exec",
        ),
        "_otbn_data": attr.label(
            default = "//hw/ip/otbn/data:all_files",
            allow_files = True,
        ),
        "_simulator": attr.label(
            default = "//hw/ip/otbn/dv/otbnsim:standalone",
            executable = True,
            cfg = "exec",
        ),
        "_sim_test_wrapper": attr.label(
            default = "//hw/ip/otbn/util:otbn_sim_test",
            executable = True,
            cfg = "exec",
        ),
        "_wrapper": attr.label(
            default = "//util:otbn_build",
            executable = True,
            cfg = "exec",
        ),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
    incompatible_use_toolchain_transition = True,
)

otbn_consttime_test = rule(
    implementation = _otbn_consttime_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [OutputGroupInfo]),
        "subroutine": attr.string(),
        "secrets": attr.string_list(),
        "initial_constants": attr.string_list(),
        "_checker": attr.label(
            default = "//hw/ip/otbn/util:check_const_time",
            executable = True,
            cfg = "exec",
        ),
    },
)

otbn_insn_count_range = rule(
    implementation = _otbn_insn_count_range,
    attrs = {
        "deps": attr.label_list(providers = [OutputGroupInfo]),
        "_counter": attr.label(
            default = "//hw/ip/otbn/util:get_instruction_count_range.py",
            allow_single_file = True,
        ),
    },
)
