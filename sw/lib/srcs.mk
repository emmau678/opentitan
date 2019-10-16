# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

GEN_HEADERS       += $(LIB_LOC_DIF_SRCS:.c=_regs.h) sw/boot_rom/chip_info.h
LIB_LOC_DIF_SRCS  += uart.c gpio.c spi_device.c flash_ctrl.c hmac.c usbdev.c rv_timer.c
LIB_LOC_EXT_SRCS  += usb_controlep.c usb_simpleserial.c irq.c handler.c irq_vectors.S

LIB_SRCS          += $(addprefix $(LIB_DIR)/, $(LIB_LOC_DIF_SRCS) $(LIB_LOC_EXT_SRCS))
