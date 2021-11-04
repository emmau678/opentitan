// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
#define OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_

#include <assert.h>
#include <stddef.h>
#include <stdint.h>

/**
 * @file
 * @brief Generic preprocessor macros that don't really fit anywhere else.
 */

/**
 * Computes the number of elements in the given array.
 *
 * Note that this can only determine the length of *fixed-size* arrays. Due to
 * limitations of C, it will incorrectly compute the size of an array passed as
 * a function argument, because those automatically decay into pointers. This
 * function can only be used correctly with:
 * - Arrays declared as stack variables.
 * - Arrays declared at global scope.
 * - Arrays that are members of a struct or union.
 *
 * @param array The array expression to measure.
 * @return The number of elements in the array, as a `size_t`.
 */
#define ARRAYSIZE(array) (sizeof(array) / sizeof(array[0]))

/**
 * An annotation that a switch/case fallthrough is the intended behavior.
 */
#define FALLTHROUGH_INTENDED __attribute__((fallthrough))

/**
 * A directive to force the compiler to inline a function.
 */
#define ALWAYS_INLINE __attribute__((always_inline)) inline

/**
 * A variable-argument macro that expands to the number of arguments passed into
 * it, between 0 and 31 arguments.
 *
 * This macro is based off of a well-known preprocessor trick. This
 * StackOverflow post expains the trick in detail:
 * https://stackoverflow.com/questions/2308243/macro-returning-the-number-of-arguments-it-is-given-in-c
 * TODO #2026: a dummy token is required for this to work correctly.
 *
 * @param dummy a dummy token that is required to be passed for the calculation
 *              to work correctly.
 * @param ... the variable args list.
 */

// Implementation details for `GET_NUM_VARIABLE_ARGS()`.
#define GET_NUM_VARIABLE_ARGS(dummy, ...)                                      \
  SHIFT_N_VARIABLE_ARGS_(dummy, ##__VA_ARGS__, 31, 30, 29, 28, 27, 26, 25, 24, \
                         23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11,   \
                         10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
#define SHIFT_N_VARIABLE_ARGS_(...) GET_NTH_VARIABLE_ARG_(__VA_ARGS__)
#define GET_NTH_VARIABLE_ARG_(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, \
                              x11, x12, x13, x14, x15, x16, x17, x18, x19, \
                              x20, x21, x22, x23, x24, x25, x26, x27, x28, \
                              x29, x30, x31, n, ...)                       \
  n

/**
 * A macro that expands to an assertion for the offset of a struct member.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param offset Expected offset of the member.
 */
#define OT_ASSERT_MEMBER_OFFSET(type, member, offset)       \
  static_assert(offsetof(type, member) == UINT32_C(offset), \
                "Unexpected offset for " #type "." #member)

/**
 * A macro that expands to an assertion for the size of a type.
 *
 * @param type A type.
 * @param size Expected size of the type.
 */
#define OT_ASSERT_SIZE(type, size) \
  static_assert(sizeof(type) == UINT32_C(size), "Unexpected size for " #type)

/**
 * A macro representing the OpenTitan execution platform.
 */
#if __riscv_xlen == 32
#define OT_PLATFORM_RV32 1
#endif

/**
 * Attribute for functions which return errors that must be acknowledged.
 *
 * This attribute must be used to mark all DIFs which return an error value of
 * some kind, to ensure that callers do not accidentally drop the error on the
 * ground.
 *
 * Normally, the standard way to drop such a value on the ground explicitly is
 * with the syntax `(void)expr;`, in analogy with the behavior of C++'s
 * `[[nodiscard]]` attribute.
 * However, GCC does not implement this, so the idiom `if (expr) {}` should be
 * used instead, for the time being.
 * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=25509.
 */
#define OT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))

/**
 * Attribute for weak functions that can be overridden, e.g., ISRs.
 */
#define OT_ATTR_WEAK __attribute__((weak))

#endif  // OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
