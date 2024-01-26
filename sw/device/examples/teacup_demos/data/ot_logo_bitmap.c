// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stddef.h>
#include <stdint.h>

#include "sw/device/examples/teacup_demos/data/bitmaps.h"

const uint16_t kOtLogoBitmapArray[64][61] = {
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xd6ba, 0x4a49, 0x4228, 0x4229, 0x4229, 0x4208, 0x5acb,
        0xf79e, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xdefc, 0x4a6a, 0x4208,
        0x4229, 0x4229, 0x4208, 0x528a, 0xe75d, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cd3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0xce7a, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xad75, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbdf7, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9d14, 0x0000, 0x0041, 0x0021, 0x0021, 0x0021, 0x0021,
        0xd69a, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xb596, 0x0000, 0x0021,
        0x0021, 0x0021, 0x0021, 0x0000, 0xc618, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cf4, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xd69a, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xb596, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbe18, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cf3, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xce79, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xad76, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbdf7, 0xffff, 0xffdf, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xa535, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xdefb, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xbdd7, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xce59, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xc639, 0xbdf7, 0xbdf8, 0xbdf8,
        0xbdf7, 0xc618, 0x73af, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x9cd3, 0xd69a, 0xffff, 0xffff, 0xffdf, 0xce59, 0x8410, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0x8c92, 0xc618, 0xbdf7, 0xbdf8, 0xbdf8,
        0xbdf7, 0xce79, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x18e3, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x31c7, 0xffff, 0xffff, 0xf79e, 0x18c3, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x39e7, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x2104, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x4208, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021,
        0x0000, 0x39e7, 0xffff, 0xffff, 0xf79e, 0x18e4, 0x0000, 0x0021, 0x0021,
        0x0021, 0x0021, 0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0x2104, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x4249, 0xffff, 0xffff, 0xffdf, 0x2145, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x4208, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xc659, 0x4a49,
        0x4249, 0x4249, 0x4249, 0x4249, 0x4229, 0x0841, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x4249, 0xbdf7, 0xb5b7, 0xbdd7, 0xbdd7, 0xbdd7, 0xbdd7,
        0xb5b7, 0xe71c, 0xffff, 0xffff, 0xffff, 0xd6db, 0xb5b6, 0xbdd7, 0xbdd7,
        0xbdd7, 0xbdd7, 0xb5d7, 0xbdd7, 0x2986, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x1082, 0x4249, 0x4249, 0x4249, 0x4249, 0x4229, 0x528a, 0xdefb,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8410, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x634d, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffdf, 0xffff, 0xffdf, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0x4228, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xad55,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8c51, 0x0000,
        0x0041, 0x0021, 0x0021, 0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffdf, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffdf, 0xffff, 0x3a08, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021, 0x0041, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8451, 0x0000,
        0x0021, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffff, 0xef7d, 0x8431, 0x8430, 0x8430,
        0x8430, 0x8430, 0x8430, 0x8430, 0x8430, 0x8430, 0x8430, 0x8430, 0x8410,
        0x8c72, 0xffdf, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8c51, 0x0000,
        0x0041, 0x0021, 0x0021, 0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffff, 0xd6ba, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0041, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021, 0x0041, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8410, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffff, 0xdedb, 0x0841, 0x0021, 0x0021,
        0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0020,
        0x18c3, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xa555,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xc638, 0x4228,
        0x4208, 0x4208, 0x4208, 0x4208, 0x3a08, 0x0862, 0x0020, 0x0021, 0x0021,
        0x0041, 0x0000, 0x630c, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0041, 0x0021, 0x0021,
        0x0020, 0x10a3, 0x4208, 0x3a08, 0x4208, 0x4208, 0x3a08, 0x4a49, 0xdefb,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0x10a3, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x632d, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x31c7, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xa534, 0x94b3, 0x9cd3, 0x9cd3,
        0x9cd3, 0x9cd3, 0xdefb, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0xd69a, 0x94b2, 0x9cd3, 0x9cd3, 0x9cd3,
        0x94b2, 0xb596, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xb596, 0xa534, 0xa535, 0xa535,
        0xa535, 0xa535, 0xe73c, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0xd6db, 0xa534, 0xa555, 0xa535, 0xa555,
        0xa534, 0xbdf7, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0x10a3, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x6b4d, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0x4229, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x39c7, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xce59, 0x4a6a,
        0x4a6a, 0x4a69, 0x4a69, 0x4a6a, 0x4a49, 0x0862, 0x0020, 0x0021, 0x0021,
        0x0041, 0x0000, 0x630c, 0xffff, 0xffff, 0xd6db, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x10c3, 0xf79e, 0xffff, 0xffff, 0x3a08, 0x0000, 0x0041, 0x0021, 0x0021,
        0x0020, 0x10a3, 0x4a6a, 0x4a69, 0x4a69, 0x4a69, 0x4a49, 0x52aa, 0xdefc,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8410, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x632c, 0xffff, 0xffff, 0xdedb, 0x0841, 0x0021, 0x0021,
        0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0021, 0x0020,
        0x18e4, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xad55,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8c51, 0x0000,
        0x0041, 0x0021, 0x0021, 0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffff, 0xd6ba, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0041, 0xf79e, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021, 0x0041, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8451, 0x0000,
        0x0021, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffff, 0xef5d, 0x7bef, 0x7bcf, 0x7bcf,
        0x7bcf, 0x7bcf, 0x7bcf, 0x7bcf, 0x7bcf, 0x7bcf, 0x7bcf, 0x7bcf, 0x73cf,
        0x8430, 0xffdf, 0xffff, 0xffff, 0x4208, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8c51, 0x0000,
        0x0041, 0x0021, 0x0021, 0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x630c, 0xffff, 0xffdf, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffdf, 0xffff, 0x3a08, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021, 0x0041, 0x0000, 0xad75,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0xffff, 0x8410, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x634d, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffdf, 0xffdf, 0xffdf, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0x4228, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0xa555,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xc618, 0x4208,
        0x3a08, 0x3a08, 0x39e8, 0x3a08, 0x39e8, 0x0841, 0x0000, 0x0000, 0x0000,
        0x0021, 0x0000, 0x4a49, 0xc638, 0xbdf8, 0xc618, 0xc618, 0xc618, 0xc618,
        0xbdf8, 0xe73d, 0xffff, 0xffff, 0xffff, 0xdefb, 0xbdf8, 0xc618, 0xc618,
        0xc618, 0xc618, 0xc618, 0xc638, 0x3186, 0x0000, 0x0021, 0x0000, 0x0000,
        0x0000, 0x0882, 0x3a08, 0x39e8, 0x39e8, 0x3a08, 0x39e8, 0x4249, 0xdedb,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffdf, 0x2104, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x4a6a, 0xffff, 0xffff, 0xffdf, 0x2966, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x4208, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39c7, 0xffff, 0xffff, 0xf79e, 0x18e4, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x1904, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x3a08, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x2124, 0x0000, 0x0021, 0x0021,
        0x0021, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x39e8, 0xffff, 0xffff, 0xf79e, 0x2104, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021, 0x0021, 0x0021, 0x0021,
        0x0000, 0x4208, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xf7be, 0x10c3, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0021,
        0x0000, 0x31a7, 0xffff, 0xffff, 0xf79e, 0x10c3, 0x0000, 0x0021, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x39c7, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xbdf7, 0xad96, 0xb596, 0xb596,
        0xad76, 0xb5b6, 0x6b6e, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0x8c72, 0xc638, 0xffff, 0xffff, 0xffdf, 0xbdf7, 0x7bcf, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x8431, 0xb5b6, 0xad96, 0xb596, 0xb596,
        0xad76, 0xc638, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xa555, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xdefb, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xbdd7, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xce59, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cf3, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xce79, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xad76, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbdf7, 0xffff, 0xffdf, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cf4, 0x0000, 0x0021, 0x0000, 0x0000, 0x0000, 0x0000,
        0xd69a, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xb596, 0x0000, 0x0021,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbe18, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9d14, 0x0000, 0x0041, 0x0021, 0x0021, 0x0021, 0x0021,
        0xd69a, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xb596, 0x0000, 0x0021,
        0x0021, 0x0021, 0x0021, 0x0000, 0xc618, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffdf, 0xffff, 0x9cd3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0xce79, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xad75, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0xbdf7, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xce9a, 0x3a08, 0x39c7, 0x39e7, 0x39e8, 0x31c7, 0x528a,
        0xef7d, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xdefb, 0x4228, 0x39c7,
        0x39e7, 0x39e7, 0x39c7, 0x4a49, 0xe73c, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    },
    {
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
        0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff,
    }};

const screen_bitmap_t kOtLogoBitmap = {.num_rows = 64,
                                       .num_cols = 61,
                                       .bitmap = kOtLogoBitmapArray[0],
                                       .fill_color = 0xFFFF};
