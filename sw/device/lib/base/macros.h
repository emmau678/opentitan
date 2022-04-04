// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
#define OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_

// This file may be used in .S files, in which case standard library includes
// should be elided.
#ifndef __ASSEMBLER__
#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#endif

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
// This is a sufficiently well-known macro that we don't really need to bother
// with a prefix like the others, and a rename will cause churn.
#define ARRAYSIZE(array) (sizeof(array) / sizeof(array[0]))

/**
 * An annotation that a switch/case fallthrough is the intended behavior.
 */
#define OT_FALLTHROUGH_INTENDED __attribute__((fallthrough))

/**
 * A directive to force the compiler to inline a function.
 */
#define OT_ALWAYS_INLINE __attribute__((always_inline)) inline

/**
 * The `restrict` keyword is C specific, so we provide a C++-portable wrapper
 * that uses the GCC name.
 *
 * It only needs to be used in headers; .c files can use `restrict` directly.
 */
#define OT_RESTRICT __restrict__

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
#define OT_VA_ARGS_COUNT(dummy, ...)                                          \
  OT_SHIFT_N_VARIABLE_ARGS_(dummy, ##__VA_ARGS__, 31, 30, 29, 28, 27, 26, 25, \
                            24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13,   \
                            12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)

// Implementation details for `OT_VA_ARGS_COUNT()`.
#define OT_SHIFT_N_VARIABLE_ARGS_(...) OT_GET_NTH_VARIABLE_ARG_(__VA_ARGS__)
#define OT_GET_NTH_VARIABLE_ARG_(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, \
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
 * A macro that expands to an assertion for the size of a struct member.
 *
 * @param type A struct type.
 * @param member A member of the struct.
 * @param size Expected size of the type.
 */
#define OT_ASSERT_MEMBER_SIZE(type, member, size)             \
  static_assert(sizeof(((type){0}).member) == UINT32_C(size), \
                "Unexpected size for " #type)

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
 * A macro indicating whether software should assume reduced hardware
 * support (for the `top_englishbreakafst` toplevel).
 */
#ifdef OT_IS_ENGLISH_BREAKFAST_REDUCED_SUPPORT_FOR_INTERNAL_USE_ONLY_
#define OT_IS_ENGLISH_BREAKFAST 1
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
#define OT_WEAK __attribute__((weak))

/**
 * Attribute to construct functions without prologue/epilogue sequences.
 *
 * Only basic asm statements can be safely included in naked functions.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Function-Attributes.html
 * #RISC-V-Function-Attributes
 */
#define OT_NAKED __attribute__((naked))

/**
 * Attribute to place symbols into particular sections.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
 * #Common-Function-Attributes
 */
#define OT_SECTION(name) __attribute__((section(name)))

/**
 * Returns the address of the current function stack frame.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Return-Address.html.
 */
#define OT_FRAME_ADDR() __builtin_frame_address(0)

/**
 * Hints to the compiler that some point is not reachable.
 *
 * One use case could be a function that never returns.
 *
 * Please not that if the control flow reaches the point of the
 * __builtin_unreachable, the program is undefined.
 *
 * See https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html.
 */
#define OT_UNREACHABLE() __builtin_unreachable()

/**
 * Attribute for weak alias that can be overridden, e.g., Mock overrides in
 * DIFs.
 */
#define OT_ALIAS(name) __attribute__((alias(name)))

/**
 * Defines a local symbol named `kName_` whose address resolves to the
 * program counter value an inline assembly block at this location would
 * see.
 *
 * The primary intention of this macro is to allow for peripheral tests to be
 * written that want to assert that a specific program counter reported by the
 * hardware corresponds to actual code that executed.
 *
 * For example, suppose that we're waiting for an interrupt to fire, and want
 * to verify that it fired in a specific region. We have two volatile globals:
 * `irq_happened`, which the ISR sets before returning, and `irq_pc`, which
 * the ISR sets to whatever PC the hardware reports it came from. The
 * code below tests that the reported PC matches expectations.
 *
 * ```
 * OT_ADDRESSABLE_LABEL(kIrqWaitStart);
 * enable_interrupts();
 * while(!irq_happened) {
 *   wait_for_interrupt();
 * }
 * OT_ADDRESSABLE_LABEL(kIrqWaitEnd);
 *
 * CHECK(irq_pc >= &kIrqWaitStart && irq_pc < &IrqWaitEnd);
 * ```
 *
 * Note that this only works if all functions called between the two labels
 * are actually inlined; if the interrupt fires inside of one of those two
 * functions, it will appear to not have the right PC, even though it is
 * logically inside the pair of labels.
 *
 * # Volatile Semantics
 *
 * This has the same semantics as a `volatile` inline assembly block: it
 * may be reordered with respect to all operations except other volatile
 * operations (i.e. volatile assembly and volatile read/write, such as
 * MMIO). For example, in the following code, `kBefore` and `kAfter` can
 * wind up having the same address:
 *
 * ```
 * OT_ADDRESSABLE_LABEL(kBefore);
 * x += 5;
 * OT_ADDRESSABLE_LABEL(kAfter);
 * ```
 *
 * Because it can be reordered and the compiler is free to emit whatever
 * instructions it likes, comparing a program counter value obtained from
 * the hardware with a symbol emitted by this macro is brittle (and,
 * ultimately, futile). Instead, it should be used in pairs to create a
 * range of addresses that a value can be checked for being within.
 *
 * For this primitive to work correctly there must be something that counts as
 * a volatile operation between the two labels. These include:
 *
 * - Direct reads or writes to MMIO registers or CSRs.
 * - A volatile assembly block with at least one instruction.
 * - Any DIF or driver call that may touch an MMIO register or a CSR.
 * - `LOG`ging, `printf`ing, or `CHECK`ing.
 * - `wait_for_interrupt()`.
 * - `barrier32()`, but NOT `launder32()`.
 *
 * This macro should not be used on the host side. It will compile, but will
 * probably not provide any meaningful values. In the future, it may start
 * producing a garbage value on the host side.
 *
 * # Symbol Access
 *
 * The symbol reference `kName_` will only be scoped to the current block
 * in a function, but it can be redeclared in the same file with
 *
 * ```
 * extern const char kName_[];
 * ```
 *
 * if needed elsewhere (although this should be avoided for readability's sake).
 * The name of the constant is global to the current `.c` file only.
 *
 * # Example Uses
 */
#define OT_ADDRESSABLE_LABEL(kName_)                                         \
  extern const char kName_[];                                                \
  asm volatile(".local " #kName_ "; " #kName_ ":;");                         \
  /* Force this to be at function scope. It could go at global scope, but it \
   * would give a garbage value dependent on the whims of the linker. */     \
  do {                                                                       \
  } while (false)

/**
 * Evaluates and discards `expr_`.
 *
 * This is needed because ‘(void)expr;` does not work for gcc.
 */
#define OT_DISCARD(expr_) \
  if (expr_) {            \
  }

#endif  // OPENTITAN_SW_DEVICE_LIB_BASE_MACROS_H_
