# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# TODO(drewmacrae) this should be in rules_cc
# pending resolution of https://github.com/bazelbuild/rules_cc/issues/75
load("//rules:bugfix.bzl", "find_cc_toolchain")

"""Rules to build OpenTitan for the RiscV target"""

OPENTITAN_CPU = "@bazel_embedded//constraints/cpu:riscv32"
OPENTITAN_PLATFORM = "@bazel_embedded//platforms:opentitan_rv32imc"

_targets_compatible_with = {
    OPENTITAN_PLATFORM: [OPENTITAN_CPU],
}

# This constant holds a dictionary of per-device dependencies which are used to
# generate slightly different binaries for each hardware target, including two
# simulation platforms (DV and Verilator), and two FPGA platforms (NexysVideo
# and CW310).
PER_DEVICE_DEPS = {
    "sim_verilator": ["//sw/device/lib/arch:sim_verilator"],
    "sim_dv": ["//sw/device/lib/arch:sim_dv"],
    "fpga_nexysvideo": ["//sw/device/lib/arch:fpga_nexysvideo"],
    "fpga_cw310": ["//sw/device/lib/arch:fpga_cw310"],
}

def _opentitan_transition_impl(settings, attr):
    return {"//command_line_option:platforms": attr.platform}

opentitan_transition = transition(
    implementation = _opentitan_transition_impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)

def _obj_transform_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx)
    outputs = []
    for src in ctx.files.srcs:
        binary = ctx.actions.declare_file("{}.{}".format(src.basename, ctx.attr.suffix))
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

obj_transform = rule(
    implementation = _obj_transform_impl,
    cfg = opentitan_transition,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "suffix": attr.string(default = "bin"),
        "format": attr.string(default = "binary"),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    toolchains = ["@rules_cc//cc:toolchain_type"],
)

def _sign_bin_impl(ctx):
    outputs = []
    signed_image = ctx.actions.declare_file(
        "{0}.{1}.signed.bin".format(
            # Remove ".bin" from file basename.
            ctx.file.bin.basename.replace("." + ctx.file.bin.extension, ""),
            ctx.attr.key_name,
        ),
    )
    outputs.append(signed_image)
    ctx.actions.run(
        outputs = [signed_image],
        inputs = [
            ctx.file.bin,
            ctx.file.elf,
            ctx.file.key,
            ctx.file._tool,
        ],
        arguments = [
            "rom_ext",
            ctx.file.bin.path,
            ctx.file.key.path,
            ctx.file.elf.path,
            signed_image.path,
        ],
        executable = ctx.file._tool.path,
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

sign_bin = rule(
    implementation = _sign_bin_impl,
    cfg = opentitan_transition,
    attrs = {
        "bin": attr.label(allow_single_file = True),
        "elf": attr.label(allow_single_file = True),
        "key": attr.label(
            default = "//sw/device/silicon_creator/mask_rom/keys:test_private_key_0",
            allow_single_file = True,
        ),
        "key_name": attr.string(),
        # TODO(lowRISC/opentitan:#11199): explore other options to side-step the
        # need for this transition, in order to build the ROM_EXT signer tool.
        "platform": attr.string(default = "@local_config_platform//:host"),
        "_tool": attr.label(
            default = "//sw/host/rom_ext_image_tools/signer:rom_ext_signer",
            allow_single_file = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def _elf_to_disassembly_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx)
    outputs = []
    for src in ctx.files.srcs:
        disassembly = ctx.actions.declare_file("{}.dis".format(src.basename))
        outputs.append(disassembly)
        ctx.actions.run_shell(
            outputs = [disassembly],
            inputs = [src] + cc_toolchain.all_files.to_list(),
            arguments = [
                cc_toolchain.objdump_executable,
                src.path,
                disassembly.path,
            ],
            command = "$1 --disassemble --headers --line-numbers --source $2 > $3",
        )
        return [DefaultInfo(
            files = depset(outputs),
            data_runfiles = ctx.runfiles(files = outputs),
        )]

elf_to_disassembly = rule(
    implementation = _elf_to_disassembly_impl,
    cfg = opentitan_transition,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain"),
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
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
                ctx.files._tool[0],
                ctx.files._config[0],
            ],
            arguments = [
                ctx.files._config[0].path,
                src.path,
                scrambled.path,
            ],
            executable = ctx.files._tool[0].path,
        )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

elf_to_scrambled_rom_vmem = rule(
    implementation = _elf_to_scrambled_rom_impl,
    cfg = opentitan_transition,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_tool": attr.label(
            default = "//hw/ip/rom_ctrl/util:scramble_image.py",
            allow_files = True,
        ),
        "_config": attr.label(
            default = "//hw/top_earlgrey/data:autogen/top_earlgrey.gen.hjson",
            allow_files = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def _bin_to_flash_vmem_impl(ctx):
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

bin_to_flash_vmem = rule(
    implementation = _bin_to_flash_vmem_impl,
    cfg = opentitan_transition,
    attrs = {
        "bin": attr.label(allow_single_file = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "word_size": attr.int(
            default = 64,
            doc = "Word size of VMEM file.",
            mandatory = True,
            values = [32, 64],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
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
            ctx.file._tool,
        ],
        arguments = [
            ctx.file.vmem.path,
            scrambled_vmem.path,
        ],
        executable = ctx.file._tool.path,
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

scramble_flash_vmem = rule(
    implementation = _scramble_flash_vmem_impl,
    cfg = opentitan_transition,
    attrs = {
        "vmem": attr.label(allow_single_file = True),
        "platform": attr.string(default = OPENTITAN_PLATFORM),
        "_tool": attr.label(
            default = "//util/design:gen-flash-img.py",
            allow_single_file = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def _bin_to_spiflash_frames_impl(ctx):
    outputs = []
    frames_bin = ctx.actions.declare_file("{}.frames.bin".format(
        # Remove ".bin" from file basename.
        ctx.file.bin.basename.replace("." + ctx.file.bin.extension, ""),
    ))
    outputs.append(frames_bin)
    ctx.actions.run(
        outputs = [frames_bin],
        inputs = [
            ctx.file.bin,
            ctx.file._tool,
        ],
        arguments = [
            "--input",
            ctx.file.bin.path,
            "--dump-frames",
            frames_bin.path,
        ],
        executable = ctx.file._tool.path,
    )
    return [DefaultInfo(
        files = depset(outputs),
        data_runfiles = ctx.runfiles(files = outputs),
    )]

bin_to_spiflash_frames = rule(
    implementation = _bin_to_spiflash_frames_impl,
    cfg = opentitan_transition,
    attrs = {
        "bin": attr.label(allow_single_file = True),
        # TODO(lowRISC/opentitan:#11199): explore other options to side-step the
        # need for this transition, in order to build the spiflash tool.
        "platform": attr.string(default = "@local_config_platform//:host"),
        "_tool": attr.label(
            default = "//sw/host/spiflash",
            allow_single_file = True,
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
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
            default = "//util/device_sw_utils:extract_sw_logs_db",
            cfg = "host",
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
        output_bin = True,
        output_disassembly = True,
        extract_sw_logs_db = False,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts.

    This macro is mostly a wrapper around cc_binary, but creates artifacts
    compatible with OpenTitan binaries. The actual artifacts created are an ELF
    file, a BIN file, the disassembly, and a log message database (text file)
    for the DV simulation testbench. Each of these output targets performs a
    bazel transition to the RV32I toolchain to build the target under the
    correct compiler.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param output_bin: Whether to emit a BIN file.
      @param output_disassembly: Whether to emit a disassembly file.
      @param extract_sw_logs_db: Whether to emit a log database for DV testbench.
      @param **kwargs: Arguments to forward to `cc_binary`.
    Emits rules:
      cc_binary             named: <name>
      optionally:
        obj_transform       named: <name>_bin
        elf_to_dissassembly named: <name>_dis
        gen_sim_dv_logs_db  named: <name>_sim_dv_logs
      filegroup             named: <name>
          with all the generated rules
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

    # Generate ELF
    native.cc_binary(
        name = name,
        deps = deps,
        target_compatible_with = _targets_compatible_with[platform],
        copts = copts,
        linkopts = linkopts,
        **kwargs
    )
    elf_name = "{}_{}".format(name, "elf")
    targets.append(":" + elf_name)
    obj_transform(
        name = elf_name,
        srcs = [name],
        format = "elf32-little",
        suffix = "elf",
        platform = platform,
    )

    # Generate Binary
    if output_bin:
        bin_name = "{}_{}".format(name, "bin")
        targets.append(":" + bin_name)
        obj_transform(
            name = bin_name,
            srcs = [name],
            platform = platform,
        )

    # Generate Disassembly
    if output_disassembly:
        dis_name = "{}_{}".format(name, "dis")
        targets.append(":" + dis_name)
        elf_to_disassembly(
            name = dis_name,
            srcs = [name],
            platform = platform,
        )

    # Generate log message database for DV sim testbench
    if extract_sw_logs_db:
        logs_db_name = "{}_{}".format(name, "logs_db")
        targets.append(":" + logs_db_name)
        gen_sim_dv_logs_db(
            name = logs_db_name,
            srcs = [elf_name],
            platform = platform,
        )

    native.filegroup(
        name = name + "_base_bins",
        srcs = targets,
    )

    return targets

def opentitan_rom_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        per_device_deps = PER_DEVICE_DEPS,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts for ROM.

    This macro is mostly a wrapper around a opentitan_binary macro, which itself
    is a wrapper around cc_binary, but also creates artifacts for each of the
    keys in `per_device_deps`. The actual artifacts created are an ELF file, a
    BIN file, the disassembly, the sim_dv logs database, and the scrambled (ROM)
    VMEM file. Each of these output targets performs a bazel transition to the
    RV32I toolchain to build the target under the correct compiler.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param per_device_deps: The deps for each of the hardware target.
      @param **kwargs: Arguments to forward to `opentitan_binary`.
    Emits rules:
      For each device in per_device_deps entry:
        cc_binary                 named: <name>_<device>
        obj_transform             named: <name>_<device>_elf
        obj_transform             named: <name>_<device>_bin
        elf_to_dissassembly       named: <name>_<device>_dis
        elf_to_scrambled_rom_vmem named: <name>_<device>_scr_vmem
      For the sim_dv device:
        gen_sim_dv_logs_db        named: <name>_sim_dv_logs
      filegroup named: <name>
          with all the generated rules
    """

    deps = kwargs.pop("deps", [])
    targets = []
    for (device, dev_deps) in per_device_deps.items():
        devname = "{}_{}".format(name, device)

        # Generate ELF, Binary, Disassembly, and (maybe) sim_dv logs database
        targets.extend(opentitan_binary(
            name = devname,
            deps = deps + dev_deps,
            extract_sw_logs_db = device == "sim_dv",
            **kwargs
        ))
        elf_name = "{}_{}".format(devname, "elf")

        # Generate Scrambled ROM VMEM
        scr_vmem_name = "{}_scr_vmem".format(devname)
        targets.append(":" + scr_vmem_name)
        elf_to_scrambled_rom_vmem(
            name = scr_vmem_name,
            srcs = [elf_name],
            platform = platform,
        )

    native.filegroup(
        name = name,
        srcs = targets,
    )

def opentitan_flash_binary(
        name,
        platform = OPENTITAN_PLATFORM,
        signing_keys = {
            "test_key_0": "//sw/device/silicon_creator/mask_rom/keys:test_private_key_0",
        },
        per_device_deps = PER_DEVICE_DEPS,
        output_signed = False,
        **kwargs):
    """A helper macro for generating OpenTitan binary artifacts for flash.

    This macro is mostly a wrapper around a opentitan_binary macro, which itself
    is a wrapper around cc_binary, but also creates artifacts for each of the
    keys in `per_device_deps`, and if signing is enabled, each of the keys in
    `signing_keys`. The actual artifacts created are an ELF file, a (signed and)
    unsigned BIN file, the disassembly, the sim_dv logs database, a (signed and)
    unsigned flash VMEM file, and a (signed and) unsigned scrambled flash VMEM
    file. Some of these output targets perform a bazel transition to the RV32I
    toolchain to build the target under the correct compiler.
    Args:
      @param name: The name of this rule.
      @param platform: The target platform for the artifacts.
      @param signing_keys: The signing keys for to sign each BIN file with.
      @param per_device_deps: The deps for each of the hardware target.
      @param output_signed: Whether or not to emit signed binary/VMEM files.
      @param **kwargs: Arguments to forward to `opentitan_binary`.
    Emits rules:
      For each device in per_device_deps entry:
        cc_binary              named: <name>_<device>
        obj_transform          named: <name>_<device>_elf
        obj_transform          named: <name>_<device>_bin
        elf_to_dissassembly    named: <name>_<device>_dis
        bin_to_flash_vmem      named: <name>_<device>_flash_vmem
        scrambled_flash_vmem   named: <name>_<device>_scr_flash_vmem
        optionally:
          sign_bin             named: <name>_<device>_bin_signed_<key_name>
          bin_to_flash_vmem    named: <name>_<device>_flash_vmem_signed_<key_name>
          scrambled_flash_vmem named: <name>_<device>_scr_flash_vmem_signed_<key_name>
      For the sim_dv device:
        gen_sim_dv_logs_db     named: <name>_sim_dv_logs
      filegroup named: <name>
          with all the generated rules
    """

    deps = kwargs.pop("deps", [])
    targets = []
    for (device, dev_deps) in per_device_deps.items():
        devname = "{}_{}".format(name, device)

        # Generate ELF, Binary, Disassembly, and (maybe) sim_dv logs database
        targets.extend(opentitan_binary(
            name = devname,
            deps = deps + dev_deps,
            extract_sw_logs_db = device == "sim_dv",
            **kwargs
        ))
        elf_name = "{}_{}".format(devname, "elf")
        bin_name = "{}_{}".format(devname, "bin")

        # Generate SPI flash frames binary for bootstrap in DV sim.
        if device == "sim_dv":
            frames_bin_name = "{}_frames_bin".format(devname)
            targets.append(":" + frames_bin_name)
            bin_to_spiflash_frames(
                name = frames_bin_name,
                bin = bin_name,
            )
            frames_vmem_name = "{}_frames_vmem".format(devname)
            targets.append(":" + frames_vmem_name)
            bin_to_flash_vmem(
                name = frames_vmem_name,
                bin = frames_bin_name,
                platform = platform,
                word_size = 32,  # Bootstrap VMEM image uses 32-bit words
            )

        # Sign BIN (if required) and generate scrambled VMEM images.
        if output_signed:
            for (key_name, key) in signing_keys.items():
                # Sign the Binary.
                signed_bin_name = "{}_bin_signed_{}".format(devname, key_name)
                targets.append(":" + signed_bin_name)
                sign_bin(
                    name = signed_bin_name,
                    bin = bin_name,
                    elf = elf_name,
                    key = key,
                    key_name = key_name,
                )

                # Generate a VMEM64 from the signed binary.
                signed_vmem_name = "{}_vmem64_signed_{}".format(
                    devname,
                    key_name,
                )
                targets.append(":" + signed_vmem_name)
                bin_to_flash_vmem(
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
                targets.append(":" + scr_signed_vmem_name)
                scramble_flash_vmem(
                    name = scr_signed_vmem_name,
                    vmem = signed_vmem_name,
                    platform = platform,
                )
        else:
            # Generate a VMEM64 from the binary.
            vmem_name = "{}_vmem64".format(devname)
            targets.append(":" + vmem_name)
            bin_to_flash_vmem(
                name = vmem_name,
                bin = bin_name,
                platform = platform,
                word_size = 64,  # Backdoor-load VMEM image uses 64-bit words
            )

            # Scramble VMEM64.
            scr_vmem_name = "{}_scr_vmem64".format(devname)
            targets.append(":" + scr_vmem_name)
            scramble_flash_vmem(
                name = scr_vmem_name,
                vmem = vmem_name,
                platform = platform,
            )

    native.filegroup(
        name = name,
        srcs = targets,
    )

def dv_params(
        rom = "//sw/device/lib/testing/test_rom:test_rom_sim_dv_scr_vmem",
        otp = "//hw/ip/otp_ctrl/data:rma_image_verilator",
        chip_sim_config = "//hw/top_earlgrey/dv:chip_sim_cfg.hjson",
        bootstrap_sw = False,  # Default to backdoor loading.
        tags = [],
        timeout = "long",  # 15 minutes
        local = True,
        args = [
            "$(location {chip_sim_config})",
        ],
        data = [],
        **kwargs):
    """A macro to create DV parameters for OpenTitan functional tests.

    This macro emits a dictionary of parameters which are pasted into the DV
    specific test rule.

    Args:
        @param rom: The ROM to use when running a DV simulation.
        @param otp: The OTP image to use when running a DV simulation.
        @param chip_sim_config: The dvsim.py HJSON chip_sim_config file for the toplevel.
        @param bootstrap_sw: Whether to load flash via bootstrap.
        @param tags: The test tags to apply to the test rule.
        @param timeout: The timeout to apply to the test rule.
        @param local: Whether the test should be run locally and without sandboxing.
        @param args: Extra arguments to pass to `dvsim.py`.
        @param data: Data dependencies of the test.
    """
    kwargs.update(
        rom = rom,
        otp = otp,
        chip_sim_config = chip_sim_config,
        bootstrap_sw = bootstrap_sw,
        tags = tags + ["dv"],
        timeout = timeout,
        local = local,
        args = args,
        data = data,
    )
    return kwargs

def verilator_params(
        rom = "//sw/device/lib/testing/test_rom:test_rom_sim_verilator_scr_vmem",
        otp = "//hw/ip/otp_ctrl/data:rma_image_verilator",
        tags = [
            "cpu:4",
        ],
        timeout = "moderate",  # 5 minutes
        local = True,
        args = [
            "console",
            "--exit-failure=FAIL",
            "--exit-success=PASS",
            "--timeout=3600",
        ],
        data = [],
        **kwargs):
    """A macro to create Verilator sim parameters for OpenTitan functional tests.

    This macro emits a dictionary of parameters which are pasted into the
    Verilator specific test rule.

    Args:
        @param rom: The ROM to use when running a Verilator simulation.
        @param otp: The OTP image to use when running a Verilator simulation.
        @param tags: The test tags to apply to the test rule.
        @param timeout: The timeout to apply to the test rule.
        @param local: Whether the test should be run locally and without sandboxing.
        @param args: Extra arguments to pass to `opentitantool`.
        @param data: Data dependencies of the test.
    """
    kwargs.update(
        rom = rom,
        otp = otp,
        tags = tags + ["verilator"],
        timeout = timeout,
        local = local,
        args = args,
        data = data,
    )
    return kwargs

def cw310_params(
        tags = [],
        timeout = "moderate",  # 5 minutes
        local = True,
        args = [
            "--exec=\"console -q -t0\"",
            "--exec=\"bootstrap $(location {test_bin})\"",
            "console",
            "--exit-failure=FAIL",
            "--exit-success=PASS",
            "--timeout=3600",
        ],
        data = [],
        **kwargs):
    """A macro to create CW310 parameters for OpenTitan functional tests.

    This macro emits a dictionary of parameters which are pasted into the
    ChipWhisperer-310 specific test rule.

    Args:
        @param tags: The test tags to apply to the test rule.
        @param timeout: The timeout to apply to the test rule.
        @param local: Whether the test should be run locally and without sandboxing.
        @param args: Extra arguments to pass to `opentitantool`.
        @param data: Data dependencies of the test.
    """
    kwargs.update(
        tags = tags + ["cw310", "exclusive"],
        timeout = timeout,
        local = local,
        args = args,
        data = data,
    )
    return kwargs

def _format_list(name, list1, datadict, **kwargs):
    """Concatenate and format list items.

    This is used to prepare substitutions in user-supplied args to the
    various test invocations (ie: the location of test_bin).
    Args:
        @param name: The name of the item in `datadict`.
        @param list1: A list of items to prepend to the list item from datadict.
        @param datadict: A dictionary of per-test parameters.
        @param **kwargs: Values to pass to the format function.
    Returns:
        list[str]
    """
    return [x.format(**kwargs) for x in list1 + datadict.pop(name, [])]

_OTTF_DEPS = [
    "//sw/device/lib/arch:device",
    "//sw/device/lib/base:macros",
    "//sw/device/lib/base:csr",
    "//sw/device/lib/base:mmio",
    "//sw/device/lib/runtime:hart",
    "//sw/device/lib/runtime:log",
    "//sw/device/lib/runtime:print",
    "//sw/device/lib/crt",
    "//sw/device/lib/testing/test_framework:ottf_start",
    "//sw/device/lib/testing/test_framework:ottf",
    "//sw/device/lib/base:mmio",
]

def _unique_deps(*deplists):
    uniq = {}
    for deplist in deplists:
        for dep in deplist:
            uniq[dep] = True
    return uniq.keys()

def opentitan_functest(
        name,
        targets = ["dv", "verilator", "cw310"],
        args = [],
        data = [],
        ottf = _OTTF_DEPS,
        test_in_rom = False,
        signed = False,
        key = "test_key_0",
        dv = None,
        verilator = None,
        cw310 = None,
        **kwargs):
    """A helper macro for generating OpenTitan functional tests.

    This macro is mostly a wrapper around opentitan_flash_binary, but creates
    testing artifacts for each of the hardware targets in `targets`. The testing
    artifacts are then given to an `sh_test` rule which dispatches the test to
    the corresponding hardware target via opentitantool.
    Args:
      @param name: The name of this rule.
      @param targets: A list of hardware targets on which to dispatch tests.
      @param args: Extra arguments to pass to the test runner (`opentitantool`
                   or `dvsim.py`).
      @param data: Extra data dependencies needed while executing the test.
      @param ottf: Default dependencies for OTTF tests. Set to empty list if
                   your test doesn't use the OTTF.
      @param test_in_rom: Whether to run the test from ROM, runs from flash by
                          default.
      @param signed: Whether to sign the test image. Unsigned by default.
      @param key: Which signed test image (by key) to use.
      @param dv: DV test parameters.
      @param verilator: Verilator test parameters.
      @param cw310: CW310 test parameters.
      @param **kwargs: Arguments to forward to `opentitan_flash_binary`.

    This macro emits the following rules:
        opentitan_flash_binary named: {name}_prog (and all emitted rules).
        sh_test                named: dv_{name}
        sh_test                named: verilator_{name}
        sh_test                named: cw310_{name}
        test_suite             named: {name}
    """

    # Generate flash artifacts for test.
    deps = _unique_deps(kwargs.pop("deps", []), ottf)
    if test_in_rom:
        opentitan_rom_binary(
            name = name + "_rom_prog",
            deps = deps,
            **kwargs
        )
    opentitan_flash_binary(
        name = name + "_prog",
        output_signed = signed,
        deps = deps,
        **kwargs
    )

    all_tests = []

    if "dv" in targets:
        # Set default DV sim parameters if none are provided.
        if dv == None:
            dv = dv_params()

        test_name = "dv_{}".format(name)

        # Regardless if the test is signed or not, DV sims backdoor load flash
        # with the scrambled VMEM (unless the bootstrap path is used below).
        test_bin = "{}_prog_sim_dv_scr_vmem64".format(name)

        # If the (flash) test image is to be loaded via bootstrap, then we need
        # to use the VMEM image that has been split into SPI flash frames.
        if dv.pop("bootstrap_sw"):
            if test_in_rom:
                fail("A test runs in ROM cannot be bootstrapped.")
            test_bin = "{}_prog_sim_dv_frames_vmem".format(name)

        if "manual" not in dv.get("tags", []):
            all_tests.append(test_name)

        rom = dv.pop("rom")
        if test_in_rom:
            rom = name + "_rom_prog_sim_dv_scr_vmem"
        otp = dv.pop("otp")
        chip_sim_config = dv.pop("chip_sim_config")
        dargs = _format_list("args", args, dv, chip_sim_config = chip_sim_config)
        ddata = _format_list("data", data, dv)

        # SW logs database files for backdoor message logging in sim.
        rom_sw_logs_db = rom.replace("_scr_vmem", "_logs_db")
        flash_sw_logs_db = "{}_prog_sim_dv_logs_db".format(name)

        native.sh_test(
            name = test_name,
            srcs = ["//util:dvsim_test_runner.sh"],
            args = [
                "-i",
                "chip_sw_{}".format(name),
            ] + dargs,
            data = [
                test_bin,
                rom,
                otp,
                chip_sim_config,
                rom_sw_logs_db,
                flash_sw_logs_db,
                "//util/dvsim",
                "//hw:all_files",
            ] + ddata,
            **dv
        )

    if "verilator" in targets:
        # Set default Verilator sim parameters if none are provided.
        if verilator == None:
            verilator = verilator_params()

        test_name = "verilator_{}".format(name)

        # If the test is unsigned, the Verilator sim can backdoor load flash
        # with the ELF.
        test_bin = "{}_prog_sim_verilator_elf".format(name)

        # If the test is signed, the Verilator sim must backdoor load flash with
        # the scrambled VMEM, since only the BIN can be signed by the ROM_EXT
        # signer tool, and this is converted to a scrambled (64-bit) VMEM.
        if signed:
            test_bin = "{}_prog_sim_verilator_scr_vmem64_signed_{}".format(
                name,
                key,
            )

        rom = verilator.pop("rom")
        if test_in_rom:
            rom = name + "_rom_prog_sim_verilator_scr_vmem"
        otp = verilator.pop("otp")
        vargs = _format_list("args", args, verilator, test_bin = test_bin)
        vdata = _format_list("data", data, verilator, test_bin = test_bin)

        if "manual" not in verilator.get("tags", []):
            all_tests.append(test_name)

        native.sh_test(
            name = test_name,
            srcs = ["//util:opentitantool_test_runner.sh"],
            args = [
                "--rcfile=",
                "--logging=info",
                "--interface=verilator",
                "--conf=sw/host/opentitantool/config/opentitan_verilator.json",
                "--verilator-bin=$(location //hw:verilator)/sim-verilator/Vchip_sim_tb",
                "--verilator-rom=$(location {})".format(rom),
                "--verilator-flash=$(location {})".format(test_bin),
                "--verilator-otp=$(location {})".format(otp),
            ] + vargs,
            data = [
                test_bin,
                rom,
                otp,
                "//sw/host/opentitantool:test_resources",
                "//hw:verilator",
            ] + vdata,
            **verilator
        )

    if "cw310" in targets:
        # Set default CW310 FPGA parameters if none are provided.
        if cw310 == None:
            cw310 = cw310_params()

        if test_in_rom:
            fail("test_in_rom only valid on simulation targets.")

        test_name = "cw310_{}".format(name)

        test_bin = "{}_prog_fpga_cw310_bin".format(name)
        if signed:
            test_bin = "{}_prog_fpga_cw310_bin_signed_{}".format(name, key)

        cargs = _format_list("args", args, cw310, test_bin = test_bin)
        cdata = _format_list("data", data, cw310, test_bin = test_bin)

        if "manual" not in cw310.get("tags", []):
            all_tests.append(test_name)

        native.sh_test(
            name = test_name,
            srcs = ["//util:opentitantool_test_runner.sh"],
            args = [
                "--rcfile=",
                "--logging=info",
                "--interface=cw310",
                "--conf=sw/host/opentitantool/config/opentitan_cw310.json",
            ] + cargs,
            data = [
                test_bin,
                "//sw/host/opentitantool:test_resources",
            ] + cdata,
            **cw310
        )

    native.test_suite(
        name = name,
        tests = all_tests,
    )
