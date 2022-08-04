# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cc_toolchain")
load(
    "@lowrisc_opentitan//rules:cc_side_outputs.bzl",
    "rv_asm",
    "rv_llvm_ir",
    "rv_preprocess",
    "rv_relink_with_linkmap",
)
load(
    "@lowrisc_opentitan//rules:rv.bzl",
    "rv_rule",
    _OPENTITAN_CPU = "OPENTITAN_CPU",
    _OPENTITAN_PLATFORM = "OPENTITAN_PLATFORM",
    _opentitan_transition = "opentitan_transition",
)

"""Rules to build OpenTitan for the RISC-V target"""

# Re-exports of names from transition.bzl; many files in the repo use opentitan.bzl
# to get to them.
OPENTITAN_CPU = _OPENTITAN_CPU
OPENTITAN_PLATFORM = _OPENTITAN_PLATFORM
opentitan_transition = _opentitan_transition

_targets_compatible_with = {
    OPENTITAN_PLATFORM: [OPENTITAN_CPU],
}

# This constant holds a dictionary of per-device dependencies which are used to
# generate slightly different binaries for each hardware target, including two
# simulation platforms (DV and Verilator), and two FPGA platforms (NexysVideo
# and CW310).
PER_DEVICE_DEPS = {
    "sim_verilator": ["@//sw/device/lib/arch:sim_verilator"],
    "sim_dv": ["@//sw/device/lib/arch:sim_dv"],
    "fpga_nexysvideo": ["@//sw/device/lib/arch:fpga_nexysvideo"],
    "fpga_cw310": ["@//sw/device/lib/arch:fpga_cw310"],
}

def _obj_transform_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx).cc
    outputs = []
    for src in ctx.files.srcs:
        binary = ctx.actions.declare_file(
            "{}.{}".format(
                src.basename.replace("." + src.extension, ""),
                ctx.attr.suffix,
            ),
        )
        outputs.append(binary)
        ctx.actions.run(
            outputs = [binary],
            inputs = [src] + cc_toolchain.all_files.to_list(),
            arguments = [
                "--output-target",
                ctx.attr.format,
                src.path,
                binary.path,
            ],
            executable = cc_toolchain.objcopy_executable,
        )
    return [DefaultInfo(files = depset(outputs), data_runfiles = ctx.runfiles(files = outputs))]

obj_transform = rv_rule(
    implementation = _obj_transform_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "suffix": attr.string(default = "bin"),
        "format": attr.string(default = "binary"),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    toolchains = ["@rules_cc//cc:toolchain_type"],
)

# A provider for device-specific archive files that hold binaries of SRAM programs.
ArchiveInfo = provider(fields = ["archive_infos"])

def _bin_to_archive_impl(ctx):
    cc_infos = []
    cc_toolchain = find_cc_toolchain(ctx).cc
    cc_info_dict = {}
    num_devices = len(ctx.attr.devices)
    num_binaries = len(ctx.attr.binaries)
    if num_devices != num_binaries:
        fail("Number of devices", num_devices, "must be equal to number of binaries", num_binaries)
    for (device, binary_target) in zip(ctx.attr.devices, ctx.attr.binaries):
        devname = "{}_{}".format(ctx.attr.name, device)
        binary_file = binary_target.files.to_list()[0]
        object_file = ctx.actions.declare_file("{}.o".format(devname))
        renamed_object_file = ctx.actions.declare_file("{}.renamed.o".format(devname))
        archive_file = ctx.actions.declare_file("{}.a".format(devname))

        # Create a CcInfo to be able to use this rule as a dependency in other rules.
        # See https://bazel.build/docs/integrating-with-rules-cc.
        feature_configuration = cc_common.configure_features(
            ctx = ctx,
            cc_toolchain = cc_toolchain,
            requested_features = ctx.features,
            unsupported_features = ctx.disabled_features,
        )
        action_name = ACTION_NAMES.cpp_link_executable
        c_linker_path = cc_common.get_tool_for_action(
            feature_configuration = feature_configuration,
            action_name = action_name,
        )
        c_link_variables = cc_common.create_link_variables(
            feature_configuration = feature_configuration,
            cc_toolchain = cc_toolchain,
            output_file = object_file.path,
        )
        command_line = cc_common.get_memory_inefficient_command_line(
            feature_configuration = feature_configuration,
            action_name = action_name,
            variables = c_link_variables,
        )
        env = cc_common.get_environment_variables(
            feature_configuration = feature_configuration,
            action_name = action_name,
            variables = c_link_variables,
        )
        linker_path = cc_common.get_tool_for_action(
            feature_configuration = feature_configuration,
            action_name = action_name,
        )

        # Create an object file that contains the binary.
        ctx.actions.run(
            executable = cc_toolchain.ld_executable,
            arguments = [
                "-r",
                "-b",
                "binary",
                "-o",
                object_file.path,
                binary_file.path,
            ],
            use_default_shell_env = False,
            env = env,
            inputs = depset(
                direct = [binary_file],
                transitive = [cc_toolchain.all_files],
            ),
            outputs = [object_file],
            mnemonic = "CppLink",
        )

        # Rename symbols to make them more manageable.
        sym_prefix = "_binary_" + binary_file.path.replace(".", "_").replace("/", "_").replace("-", "_")
        suffixes = ["start", "end", "size"]
        rename_args = []
        for suffix in suffixes:
            old_name = "{}_{}".format(sym_prefix, suffix)
            new_name = "_{}_{}".format(ctx.attr.archive_symbol_prefix, suffix)
            rename_args.extend(["--redefine-sym", "{}={}".format(old_name, new_name)])
        rename_args.extend(["--rename-section", ".data=.data.sram_program"])
        rename_args.extend([object_file.path, renamed_object_file.path])
        ctx.actions.run(
            executable = cc_toolchain.objcopy_executable,
            arguments = rename_args,
            use_default_shell_env = False,
            env = env,
            inputs = depset(
                direct = [object_file],
                transitive = [cc_toolchain.all_files],
            ),
            outputs = [renamed_object_file],
            mnemonic = "RenameSymbols",
        )

        # Create an archive that contains the object file.
        ctx.actions.run(
            executable = cc_toolchain.ar_executable,
            arguments = [
                "r",
                archive_file.path,
                renamed_object_file.path,
            ],
            use_default_shell_env = False,
            env = env,
            inputs = depset(
                direct = [renamed_object_file],
                transitive = [cc_toolchain.all_files],
            ),
            outputs = [archive_file],
            mnemonic = "Archive",
        )

        cc_info_dict[device] = CcInfo(
            compilation_context = cc_common.create_compilation_context(
                headers = depset(direct = ctx.attr.hdrs[0].files.to_list()),
            ),
            linking_context = cc_common.create_linking_context(
                linker_inputs = depset([cc_common.create_linker_input(
                    owner = ctx.label,
                    libraries = depset([cc_common.create_library_to_link(
                        actions = ctx.actions,
                        feature_configuration = feature_configuration,
                        cc_toolchain = cc_toolchain,
                        static_library = archive_file,
                    )]),
                )]),
            ),
        )

    return ArchiveInfo(archive_infos = cc_info_dict)

bin_to_archive = rv_rule(
    implementation = _bin_to_archive_impl,
    attrs = {
        "binaries": attr.label_list(allow_files = True),
        "devices": attr.string_list(),
        "hdrs": attr.label_list(allow_files = True),
        "archive_symbol_prefix": attr.string(),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
)

def _sign_bin_impl(ctx):
    signed_image = ctx.actions.declare_file(
        "{0}.{1}.signed.bin".format(
            # Remove ".bin" from file basename.
            ctx.file.bin.basename.replace("." + ctx.file.bin.extension, ""),
            ctx.attr.key_name,
        ),
    )
    outputs = [signed_image]

    inputs = [
        ctx.file.bin,
        ctx.file.key,
        ctx.file._tool,
    ]
    manifest = []
    if ctx.file.manifest:
        manifest = ["--manifest={}".format(ctx.file.manifest.path)]
        inputs.append(ctx.file.manifest)

    ctx.actions.run(
        outputs = outputs,
        inputs = inputs,
        arguments = [
            "image",
            "manifest",
            "update",
            "--key-file={}".format(ctx.file.key.path),
            "--sign",
            "--output={}".format(signed_image.path),
            ctx.file.bin.path,
        ] + manifest,
        executable = ctx.file._tool.path,
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

sign_bin = rv_rule(
    implementation = _sign_bin_impl,
    attrs = {
        "bin": attr.label(allow_single_file = True),
        "key": attr.label(
            default = "@//sw/device/silicon_creator/mask_rom/keys:test_private_key_0",
            allow_single_file = True,
        ),
        "key_name": attr.string(),
        "manifest": attr.label(allow_single_file = True),
        # TODO(lowRISC/opentitan:#11199): explore other options to side-step the
        # need for this transition, in order to build the ROM_EXT signer tool.
        "platform": attr.string(default = "@local_config_platform//:host"),
        "_tool": attr.label(
            default = "//sw/host/opentitantool:opentitantool",
            allow_single_file = True,
        ),
    },
)

def _elf_to_disassembly_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx).cc
    outputs = []
    for src in ctx.files.srcs:
        disassembly = ctx.actions.declare_file(
            "{}.dis".format(
                src.basename.replace("." + src.extension, ""),
            ),
        )
        outputs.append(disassembly)
        ctx.actions.run_shell(
            tools = [ctx.file._cleanup_script],
            outputs = [disassembly],
            inputs = [src] + cc_toolchain.all_files.to_list(),
            arguments = [
                cc_toolchain.objdump_executable,
                src.path,
                ctx.file._cleanup_script.path,
                disassembly.path,
            ],
            execution_requirements = {
                "no-sandbox": "1",
            },
            command = "$1 --disassemble --headers --line-numbers --disassemble-zeroes --source --visualize-jumps $2 | $3 > $4",
        )
        return [DefaultInfo(files = depset(outputs), data_runfiles = ctx.runfiles(files = outputs))]

elf_to_disassembly = rv_rule(
    implementation = _elf_to_disassembly_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_cleanup_script": attr.label(
            allow_single_file = True,
            default = Label("@//rules/scripts:expand_tabs.sh"),
        ),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    toolchains = ["@rules_cc//cc:toolchain_type"],
    incompatible_use_toolchain_transition = True,
)

def _elf_to_scrambled_rom_impl(ctx):
    outputs = []
    for src in ctx.files.srcs:
        if src.extension != "elf":
            fail("only ROM images in the ELF format may be converted to the VMEM format and scrambled.")
        scrambled = ctx.actions.declare_file(
            "{}.scr.39.vmem".format(
                # Remove ".elf" from file basename.
                src.basename.replace("." + src.extension, ""),
            ),
        )
        outputs.append(scrambled)
        ctx.actions.run(
            outputs = [scrambled],
            inputs = [
                src,
                ctx.executable._scramble_tool,
                ctx.file._config,
            ],
            arguments = [
                ctx.file._config.path,
                src.path,
                scrambled.path,
            ],
            executable = ctx.executable._scramble_tool,
        )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

elf_to_scrambled_rom_vmem = rv_rule(
    implementation = _elf_to_scrambled_rom_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "_scramble_tool": attr.label(
            default = "@//hw/ip/rom_ctrl/util:scramble_image",
            executable = True,
            cfg = "exec",
        ),
        "_config": attr.label(
            default = "@//hw/top_earlgrey/data:autogen/top_earlgrey.gen.hjson",
            allow_single_file = True,
        ),
    },
)

def _bin_to_vmem_impl(ctx):
    outputs = []
    vmem = ctx.actions.declare_file("{}.{}.vmem".format(
        # Remove ".bin" from file basename.
        ctx.file.bin.basename.replace("." + ctx.file.bin.extension, ""),
        ctx.attr.word_size,
    ))
    outputs.append(vmem)
    ctx.actions.run(
        outputs = [vmem],
        inputs = [
            ctx.file.bin,
        ],
        arguments = [
            ctx.file.bin.path,
            "--binary",
            # Reverse the endianness of every word.
            "--offset",
            "0x0",
            "--byte-swap",
            str(ctx.attr.word_size // 8),
            # Pad to word alignment.
            "--fill",
            "0xff",
            "-within",
            ctx.file.bin.path,
            "-binary",
            "-range-pad",
            str(ctx.attr.word_size // 8),
            # Output a VMEM file with specified word size
            "--output",
            vmem.path,
            "--vmem",
            str(ctx.attr.word_size),
        ],
        # This this executable is expected to be installed (as required by the
        # srecord package in apt-requirements.txt).
        executable = "srec_cat",
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

bin_to_vmem = rv_rule(
    implementation = _bin_to_vmem_impl,
    attrs = {
        "bin": attr.label(allow_single_file = True),
        "word_size": attr.int(
            default = 64,
            doc = "Word size of VMEM file.",
            mandatory = True,
            values = [32, 64],
        ),
    },
)

def _scramble_flash_vmem_impl(ctx):
    outputs = []
    scrambled_vmem = ctx.actions.declare_file("{}.scr.vmem".format(
        # Remove ".vmem" from file basename.
        ctx.file.vmem.basename.replace("." + ctx.file.vmem.extension, ""),
    ))
    outputs.append(scrambled_vmem)
    ctx.actions.run(
        outputs = [scrambled_vmem],
        inputs = [
            ctx.file.vmem,
            ctx.executable._tool,
        ],
        arguments = [
            ctx.file.vmem.path,
            scrambled_vmem.path,
        ],
        executable = ctx.executable._tool,
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

scramble_flash_vmem = rv_rule(
    implementation = _scramble_flash_vmem_impl,
    attrs = {
        "vmem": attr.label(allow_single_file = True),
        "_tool": attr.label(
            default = "@//util/design:gen-flash-img",
            executable = True,
            cfg = "exec",
        ),
    },
)

def _gen_sim_dv_logs_db_impl(ctx):
    outputs = []
    for src in ctx.files.srcs:
        if src.extension != "elf":
            fail("can only generate DV logs database files from ELF files.")
        logs_db = ctx.actions.declare_file("{}.logs.txt".format(
            src.basename.replace("." + src.extension, ""),
        ))
        rodata = ctx.actions.declare_file("{}.rodata.txt".format(
            src.basename.replace("." + src.extension, ""),
        ))
        outputs.append(logs_db)
        outputs.append(rodata)

        ctx.actions.run(
            outputs = outputs,
            inputs = [src],
            arguments = [
                "--elf-file",
                src.path,
                "--rodata-sections",
                ".rodata",
                "--logs-fields-section",
                ".logs.fields",
                "--name",
                src.basename.replace("." + src.extension, ""),
                "--outdir",
                logs_db.dirname,
            ],
            executable = ctx.executable._tool,
        )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

gen_sim_dv_logs_db = rule(
    implementation = _gen_sim_dv_logs_db_impl,
    cfg = opentitan_transition,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_tool": attr.label(
            default = "@//util/device_sw_utils:extract_sw_logs_db",
            cfg = "exec",
            executable = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def opentitan_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        extract_sw_logs_db = False,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts.

    This macro is mostly a wrapper around cc_binary, but creates artifacts
    compatible with OpenTitan binaries. The actual artifacts created are outputs
    of the rules listed below.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param extract_sw_logs_db: Whether to emit a log database for DV testbench.
      @param **kwargs: Arguments to forward to `cc_binary`.
    Emits rules:
      cc_binary             named: <name>
      rv_preprocess         named: <name>_preproc
      rv_asm                named: <name>_asm
      rv_llvm_ir            named: <name>_ll
      rv_relink_with_map    named: <name>_map
      obj_transform         named: <name>_elf
      obj_transform         named: <name>_bin
      elf_to_dissassembly   named: <name>_dis
      Optionally:
        gen_sim_dv_logs_db  named: <name>_logs_db
    Returns:
      List of targets generated by all of the above rules.
    """

    copts = kwargs.pop("copts", []) + [
        "-nostdlib",
        "-ffreestanding",
    ]
    linkopts = kwargs.pop("linkopts", []) + [
        "-nostartfiles",
        "-nostdlib",
    ]
    deps = kwargs.pop("deps", [])
    targets = []

    native_binary_name = "{}.elf".format(name)
    native.cc_binary(
        name = native_binary_name,
        deps = deps,
        target_compatible_with = _targets_compatible_with[platform],
        copts = copts,
        linkopts = linkopts,
        **kwargs
    )

    preproc_name = "{}_{}".format(name, "preproc")
    targets.append(preproc_name)
    rv_preprocess(
        name = preproc_name,
        target = native_binary_name,
    )

    asm_name = "{}_{}".format(name, "asm")
    targets.append(asm_name)
    rv_asm(
        name = asm_name,
        target = native_binary_name,
    )

    ll_name = "{}_{}".format(name, "ll")
    targets.append(ll_name)
    rv_llvm_ir(
        name = ll_name,
        target = native_binary_name,
    )

    map_name = "{}_{}".format(name, "map")
    targets.append(map_name)
    rv_relink_with_linkmap(
        name = map_name,
        target = native_binary_name,
    )

    bin_name = "{}_{}".format(name, "bin")
    targets.append(":" + bin_name)
    obj_transform(
        name = bin_name,
        srcs = [native_binary_name],
        platform = platform,
    )

    dis_name = "{}_{}".format(name, "dis")
    targets.append(":" + dis_name)
    elf_to_disassembly(
        name = dis_name,
        srcs = [native_binary_name],
        platform = platform,
    )

    # Generate log message database for DV sim testbench
    if extract_sw_logs_db:
        logs_db_name = "{}_{}".format(name, "logs_db")
        targets.append(":" + logs_db_name)
        gen_sim_dv_logs_db(
            name = logs_db_name,
            srcs = [native_binary_name],
            platform = platform,
        )

    return targets

def opentitan_rom_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts for ROM.

    This macro is mostly a wrapper around the `opentitan_binary` macro, but also
    creates artifacts for each of the keys in `PER_DEVICE_DEPS`. The actual
    artifacts created are outputs of the rules emitted by the `opentitan_binary`
    macro and those listed below.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param **kwargs: Arguments to forward to `opentitan_binary`.
    Emits rules:
      For each device in per_device_deps entry:
        rules emitted by `opentitan_binary` named: see `opentitan_binary` macro
        bin_to_rom_vmem                     named: <name>_<device>_vmem
        elf_to_scrambled_rom_vmem           named: <name>_<device>_scr_vmem
        filegroup                           named: <name>_<device>
          Containing all targets for a single device for the above generated rules.
        filegroup                           named: <name>
          Containing all targets across all devices for the above generated rules.
    Returns:
      List of targets generated by all the above rules (except the filegroup).
    """

    deps = kwargs.pop("deps", [])
    all_targets = []
    for (device, dev_deps) in PER_DEVICE_DEPS.items():
        devname = "{}_{}".format(name, device)
        dev_targets = []

        # Generate ELF, Binary, Disassembly, and (maybe) sim_dv logs database
        dev_targets.extend(opentitan_binary(
            name = devname,
            deps = deps + dev_deps,
            extract_sw_logs_db = device in ["sim_dv", "sim_verilator"],
            **kwargs
        ))
        elf_name = "{}.{}".format(devname, "elf")
        bin_name = "{}_{}".format(devname, "bin")

        # Generate Un-scrambled ROM VMEM
        vmem_name = "{}_vmem".format(devname)
        dev_targets.append(":" + vmem_name)
        bin_to_vmem(
            name = vmem_name,
            bin = bin_name,
            platform = platform,
            word_size = 32,
        )

        # Generate Scrambled ROM VMEM
        scr_vmem_name = "{}_scr_vmem".format(devname)
        dev_targets.append(":" + scr_vmem_name)
        elf_to_scrambled_rom_vmem(
            name = scr_vmem_name,
            srcs = [elf_name],
            platform = platform,
        )

        # Create a filegroup with just the current device's targets.
        native.filegroup(
            name = devname,
            srcs = dev_targets,
        )
        all_targets.extend(dev_targets)

    # Create a filegroup with just all targets from all devices.
    native.filegroup(
        name = name,
        srcs = all_targets,
    )

def _pick_correct_archive_for_device(ctx):
    cc_infos = []
    for dep in ctx.attr.deps:
        if CcInfo in dep:
            cc_info = dep[CcInfo]
        elif ArchiveInfo in dep:
            cc_info = dep[ArchiveInfo].archive_infos[ctx.attr.device]
        else:
            fail("Expected either a CcInfo or an ArchiveInfo")
        cc_infos.append(cc_info)
    return [cc_common.merge_cc_infos(cc_infos = cc_infos)]

pick_correct_archive_for_device = rv_rule(
    implementation = _pick_correct_archive_for_device,
    attrs = {
        "deps": attr.label_list(allow_files = True),
        "device": attr.string(),
    },
    fragments = ["cpp"],
    toolchains = ["@rules_cc//cc:toolchain_type"],
)

def opentitan_flash_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        signing_keys = {
            "test_key_0": "@//sw/device/silicon_creator/mask_rom/keys:test_private_key_0",
        },
        signed = False,
        manifest = None,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts for flash.

    This macro is mostly a wrapper around the `opentitan_binary` macro, but also
    creates artifacts for each of the keys in `PER_DEVICE_DEPS`, and if signing
    is enabled, each of the keys in `signing_keys`. The actual artifacts created
    artifacts created are outputs of the rules emitted by the `opentitan_binary`
    macro and those listed below.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param signing_keys: The signing keys for to sign each BIN file with.
      @param signed: Whether or not to emit signed binary/VMEM files.
      @param **kwargs: Arguments to forward to `opentitan_binary`.
    Emits rules:
      For each device in per_device_deps entry:
        rules emitted by `opentitan_binary` named: see `opentitan_binary` macro
        bin_to_vmem                         named: <name>_<device>_vmem64
        scrambled_flash_vmem                named: <name>_<device>_scr_vmem64
        Optionally:
          sign_bin             named: <name>_<device>_bin_signed_<key_name>
          bin_to_vmem          named: <name>_<device>_vmem64_signed_<key_name>
          scrambled_flash_vmem named: <name>_<device>_scr_vmem64_signed_<key_name>
        filegroup              named: <name>_<device>
          Containing all targets for a single device for the above generated rules.
        filegroup              named: <name>
          Containing all targets across all devices for the above generated rules.
    Returns:
      List of targets generated by all the above rules (except the filegroup).
    """

    deps = kwargs.pop("deps", [])
    all_targets = []
    for (device, dev_deps) in PER_DEVICE_DEPS.items():
        devname = "{}_{}".format(name, device)
        dev_targets = []

        depname = "{}_deps".format(devname)
        pick_correct_archive_for_device(
            name = depname,
            deps = deps + dev_deps,
            device = device,
        )

        # Generate ELF, Binary, Disassembly, and (maybe) sim_dv logs database
        dev_targets.extend(opentitan_binary(
            name = devname,
            deps = [depname],
            extract_sw_logs_db = device in ["sim_dv", "sim_verilator"],
            **kwargs
        ))
        bin_name = "{}_{}".format(devname, "bin")

        # Sign BIN (if required) and generate scrambled VMEM images.
        if signed:
            for (key_name, key) in signing_keys.items():
                # Sign the Binary.
                signed_bin_name = "{}_bin_signed_{}".format(devname, key_name)
                dev_targets.append(":" + signed_bin_name)
                sign_bin(
                    name = signed_bin_name,
                    bin = bin_name,
                    key = key,
                    key_name = key_name,
                    manifest = manifest,
                )

                # Generate a VMEM64 from the signed binary.
                signed_vmem_name = "{}_vmem64_signed_{}".format(
                    devname,
                    key_name,
                )
                dev_targets.append(":" + signed_vmem_name)
                bin_to_vmem(
                    name = signed_vmem_name,
                    bin = signed_bin_name,
                    platform = platform,
                    word_size = 64,  # Backdoor-load VMEM image uses 64-bit words
                )

                # Scramble signed VMEM64.
                scr_signed_vmem_name = "{}_scr_vmem64_signed_{}".format(
                    devname,
                    key_name,
                )
                dev_targets.append(":" + scr_signed_vmem_name)
                scramble_flash_vmem(
                    name = scr_signed_vmem_name,
                    vmem = signed_vmem_name,
                    platform = platform,
                )

        # Generate a VMEM64 from the binary.
        vmem_name = "{}_vmem64".format(devname)
        dev_targets.append(":" + vmem_name)
        bin_to_vmem(
            name = vmem_name,
            bin = bin_name,
            platform = platform,
            word_size = 64,  # Backdoor-load VMEM image uses 64-bit words
        )

        # Scramble VMEM64.
        scr_vmem_name = "{}_scr_vmem64".format(devname)
        dev_targets.append(":" + scr_vmem_name)
        scramble_flash_vmem(
            name = scr_vmem_name,
            vmem = vmem_name,
            platform = platform,
        )

        # Create a filegroup with just the current device's targets.
        native.filegroup(
            name = devname,
            srcs = dev_targets,
        )
        all_targets.extend(dev_targets)

    # Create a filegroup with just all targets from all devices.
    native.filegroup(
        name = name,
        srcs = all_targets,
    )

def opentitan_ram_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        per_device_deps = PER_DEVICE_DEPS,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts for RAM.

    This macro is mostly a wrapper around the `opentitan_binary` macro, which
    itself is a wrapper around `cc_binary`, but also creates artifacts for each
    of the keys in `per_device_deps`. The actual artifacts created are an ELF
    file, a BIN file, an archive file for embedding the program in functional
    tests, disassembly, a sim_dv logs database, and a VMEM file. Each of these
    output targets performs a bazel transition to the RV32I toolchain to build
    the target under the correct compiler.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param per_device_deps: The deps for each of the hardware target.
      @param extract_sw_logs_db: Whether to extract SW logs database for DV sim.
      @param **kwargs: Arguments to forward to `opentitan_binary`.
    Emits rules:
      For each device in per_device_deps entry:
        cc_binary                 named: <name>_<device>
        obj_transform             named: <name>_<device>_bin
        bin_to_archive            named: <name>_<device>_ar
        elf_to_dissassembly       named: <name>_<device>_dis
        bin_to_rom_vmem           named: <name>_<device>_vmem
      For the sim_dv device:
        gen_sim_dv_logs_db        named: <name>_sim_dv_logs
      filegroup named: <name>
          with all the generated rules
    """

    deps = kwargs.pop("deps", [])
    hdrs = kwargs.pop("hdrs", [])
    archive_symbol_prefix = kwargs.pop("archive_symbol_prefix")
    targets = []
    binaries = []
    for (device, dev_deps) in per_device_deps.items():
        devname = "{}_{}".format(name, device)

        # Generate ELF, binary and disassembly.
        targets.extend(opentitan_binary(
            name = devname,
            deps = deps + dev_deps,
            extract_sw_logs_db = False,
            **kwargs
        ))
        bin_name = "{}_{}".format(devname, "bin")
        binaries.append(":" + bin_name)

        # Generate the VMEM file.
        vmem_name = "{}_{}".format(devname, "vmem")
        targets.append(":" + vmem_name)
        bin_to_vmem(
            name = vmem_name,
            bin = bin_name,
            platform = platform,
            word_size = 32,
        )

    # Generate the archive file.
    archive_name = "{}_{}".format(name, "ar")
    targets.append(":" + archive_name)
    bin_to_archive(
        name = archive_name,
        hdrs = hdrs,
        binaries = binaries,
        devices = per_device_deps.keys(),
        archive_symbol_prefix = archive_symbol_prefix,
    )

    native.filegroup(
        name = name,
        srcs = targets,
    )
