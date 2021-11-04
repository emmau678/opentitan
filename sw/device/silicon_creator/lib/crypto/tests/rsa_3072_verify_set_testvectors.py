#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import argparse
import os
import sys

import hjson

'''
Read in a JSON test vector file, convert the test vector to C constants, and
generate a header file with these test vectors.
'''

HEADER_PREFIX = '''// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AUTOGENERATED. Do not edit this file by hand.
// See the crypto/tests README for details.

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_CRYPTO_TESTS_RSA_3072_VERIFY_TESTVECTORS_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_CRYPTO_TESTS_RSA_3072_VERIFY_TESTVECTORS_H_

#include "sw/device/silicon_creator/lib/crypto/rsa_3072/rsa_3072_verify.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

// A test vector for RSA-3072 verify (message hashed with SHA-256)
typedef struct rsa_3072_verify_test_vector_t {
  rsa_3072_public_key_t publicKey;  // The public key
  rsa_3072_int_t signature;         // The signature to verify
  char *msg;                        // The message
  size_t msgLen;                    // Length (in bytes) of the message
  bool valid;                       // Expected result (true if signature valid)
  char *comment;                    // Any notes about the test vector
} rsa_3072_verify_test_vector_t;

'''


HEADER_END = '''

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_CRYPTO_TESTS_RSA_3072_VERIFY_TESTVECTORS_H_
'''

# Number of 32-bit words in a 3072-bit number
RSA_3072_NUMWORDS = int(3072 / 32)


def rsa_3072_int_to_words(x):
    '''Convert a 3072-bit integer to a list of 32-bit integers (little-endian).'''
    out = []
    for _ in range(RSA_3072_NUMWORDS):
        out.append(x & ((1 << 32) - 1))
        x >>= 32
    return out


def stringify_rsa_3072_int(x, indent=0):
    prefix = ' ' * indent
    hexwords = ['{:#010x}'.format(w) for w in rsa_3072_int_to_words(x)]
    lines = []
    lines.append(prefix + '{')
    lines.append(prefix + '  .data = {')
    for i in range(0, RSA_3072_NUMWORDS, 4):
        lines.append(prefix + '    ' + ', '.join(hexwords[i:i + 4]) + ',')
    lines.append(prefix + '  }},')
    return lines


def stringify_one_test(testvec):
    lines = []
    lines.append('    {')

    # Write public key
    lines.append('        .publicKey =')
    lines.append('            {')
    lines.append('                .n =')
    lines.extend(stringify_rsa_3072_int(testvec['n'], indent=14))
    lines.append('                .e = {:#x},'.format(testvec['e']))
    lines.append('            },')

    # Write signature
    lines.append('        .signature =')
    lines.extend(stringify_rsa_3072_int(testvec['signature'], indent=10))

    # Write message data
    lines.append('        .msg = "{}",'.format(testvec['msg']))
    lines.append('        .msgLen = {:d},'.format(testvec['msg_len']))

    # Write whether signature is valid
    lines.append(
        '        .valid = {},'.format("true" if testvec['valid'] else "false"))

    # Write comments
    lines.append('        .comment = "{}",'.format(testvec['comment']))

    lines.append('    },')
    return lines


def stringify_test_vectors(testvecs):
    lines = []
    lines.append(
        'static const size_t RSA_3072_VERIFY_NUM_TESTS = {:d};'.format(
            len(testvecs)))
    lines.append('')
    lines.append('static const rsa_3072_verify_test_vector_t rsa_3072_verify_tests[{:d}] = {{'.format(len(testvecs)))
    for tv in testvecs:
        lines.extend(stringify_one_test(tv))
    lines.append('};')
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('hjsonfile',
                        metavar='FILE',
                        type=argparse.FileType('r'),
                        help='Read test vectors from this HJSON file.')
    parser.add_argument('headerfile',
                        metavar='FILE',
                        type=argparse.FileType('w'),
                        help='Write output to this file.')

    args = parser.parse_args()

    # Read test vectors and stringify them
    testvecs = hjson.load(args.hjsonfile)
    args.hjsonfile.close()
    testvecs_str = stringify_test_vectors(testvecs)

    # Write output to header file
    args.headerfile.write(HEADER_PREFIX)
    args.headerfile.write(testvecs_str)
    args.headerfile.write(HEADER_END)
    args.headerfile.close()

    return 0


if __name__ == '__main__':
    sys.exit(main())
