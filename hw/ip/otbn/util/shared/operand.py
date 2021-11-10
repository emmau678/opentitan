# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import re
from typing import List, Optional, Tuple

from serialize.parse_helpers import (check_keys, check_bool,
                                     check_str, get_optional_str)

from .encoding import Encoding
from .encoding_scheme import EncSchemeField


class OperandType:
    '''The base class for some sort of operand type

    There are three representations of an operand:

        - String
        - Operand value
        - Encoded value

    The string representation is the string that you expect to see in an
    assembly listing (either fed into otbn-as, or generated by otbn-objdump).
    The encoded value is the non-negative integer value that is encoded in the
    bits of the instruction.

    The operand value is the notional value of the operand. This might be a
    signed value (represented 2's complement in the encoded value). It might be
    shifted left by some places. This is the "value of the operand" that is
    described in the documentation.

    For a register operand, the string value might be "x3" and the operand
    value and encoded value would both be 3. Similarly, for an enum or option
    operand, the operand value and encoded value are equal.

    For an immediate operand that isn't PC-relative, converting between the
    string and operand value is essentially a call to Python's int() or str().
    The interesting conversion is between operand value and encoded value.

    '''
    def __init__(self, width: Optional[int]) -> None:
        assert width is None or width > 0
        self.width = width

    def markdown_doc(self) -> Optional[str]:
        '''Generate any (markdown) documentation for this operand type

        The base class returns None, but subclasses might return something
        useful.

        '''
        return None

    @staticmethod
    def _describe_bits_lst(bits_lst: List[str]) -> str:
        assert bits_lst
        if len(bits_lst) == 1:
            return bits_lst[0]
        else:
            return '{{{}}}'.format(', '.join(bits_lst))

    def describe_decode(self, bits_lst: List[str]) -> str:
        '''Return string saying how to interpret the raw bits of bits_str

        bits_lst is a nonempty list of string describing which bits are used to
        get the raw value.

        Overridden in subclasses if they do something non-trivial.

        '''
        return 'unsigned({})'.format(OperandType._describe_bits_lst(bits_lst))

    def syntax_determines_value(self) -> bool:
        '''Can the value of this operand always be inferred from asm syntax?

        This is true for things like registers (the value "5" only comes from
        "r5", for example), but false for arbitrary immediates: an immediate
        operand might have a value that comes from a relocation. If this is
        true, neither str_to_op_val nor op_val_to_enc_val may return None.

        '''
        return False

    def str_to_op_val(self, as_str: str) -> Optional[int]:
        '''Read the given syntax and convert it to an operand value

        See the class docstring for what "operand value" means. Raises a
        ValueError on definite failure ("found cabbage when I expected a
        register name"). Returns None on a soft failure: "this is a complicated
        looking expression, but it might be a sensible immediate".

        This function doesn't check that the result will be encodable: chain it
        with op_val_to_enc_val for that.

        '''
        raise NotImplementedError()

    def op_val_to_enc_val(self,
                          op_val: int,
                          cur_pc: Optional[int]) -> Optional[int]:
        '''Convert the operand value to an encoded value

        This expects a current PC in cur_pc. If we don't know that (because
        this is otbn-as, and we don't know our eventual current address), a
        pc_rel immediate will return None. Similarly, if we don't know our
        width, we should return None.

        Otherwise, function must check that the operand value can be
        successfully encoded (with any required shift, in self.width bits, and
        with 2's complement if signed). If not, it must raise a ValueError.

        The default implementation returns op_val (for values that are encoded
        with no shift, signedness or other cleverness) so long as the width is
        known.

        '''
        if self.width is None:
            return None

        if op_val < 0:
            raise ValueError('Negative operand value {} for a basic operand '
                             'that expects to encode an unsigned value in '
                             '{} bits.'
                             .format(op_val, self.width))
        if op_val >> self.width:
            raise ValueError('Operand value {} is too large for a basic '
                             'operand of {} bits.'
                             .format(op_val, self.width))

        return op_val

    def enc_val_to_op_val(self, enc_val: int, cur_pc: int) -> Optional[int]:
        '''Convert the encoded value to an operand value

        This needs the current PC (for pc_rel immediates) and returns the
        logical op_val. The default implementation works for values that are
        encoded with no shift, signedness or similar and returns enc_val.

        If we have a width, this function must not return None.

        '''
        return enc_val

    def op_val_to_str(self, op_val: int, cur_pc: Optional[int]) -> str:
        '''Render an operand value as a string'''
        raise NotImplementedError()

    def get_max_enc_val(self) -> Optional[int]:
        '''Return the range of valid encoded values for this operand type

        The default implementation returns None if there is no width, and
        otherwise returns the maximum value that fits in width bits.

        '''
        if self.width is None:
            return None

        return (1 << self.width) - 1

    def get_op_val_range(self, cur_pc: int) -> Optional[Tuple[int, int]]:
        '''Return the range of representable operand values

        Returns None if this isn't known, for some reason.

        The default implementation uses get_max_enc_val and applies
        enc_val_to_op_val, assuming that the function is affine linear (so the
        endpoints of the encoded range map to the endpoints of the operand
        value range). Note that this doesn't hold for 2's complement signed
        integers.

        '''
        enc_hi = self.get_max_enc_val()
        if enc_hi is None:
            return None

        op_lo = self.enc_val_to_op_val(0, cur_pc)
        assert op_lo is not None
        op_hi = self.enc_val_to_op_val(enc_hi, cur_pc)
        assert op_hi is not None

        return (min(op_lo, op_hi), max(op_lo, op_hi))


class RegOperandType(OperandType):
    '''A class representing a register operand type'''
    TYPE_FMTS = {
        'gpr': (5, 'x'),
        'wdr': (5, 'w'),
    }

    def __init__(self, reg_type: str, is_src: bool, is_dest: bool) -> None:
        fmt = RegOperandType.TYPE_FMTS.get(reg_type)
        assert fmt is not None
        width, _ = fmt

        super().__init__(width)

        self.reg_type = reg_type
        self._is_src = is_src
        self._is_dest = is_dest

    @staticmethod
    def make(reg_type: str,
             is_src: bool,
             is_dest: bool,
             what: str,
             scheme_field: Optional[EncSchemeField]) -> 'RegOperandType':
        if scheme_field is not None:
            fmt = RegOperandType.TYPE_FMTS.get(reg_type)
            assert fmt is not None
            width, _ = fmt

            if scheme_field.bits.width != width:
                raise ValueError('In {}, there is an encoding scheme that '
                                 'allocates {} bits, but the operand has '
                                 'register type {!r}, which expects {} bits.'
                                 .format(what, scheme_field.bits.width,
                                         reg_type, width))

        return RegOperandType(reg_type, is_src, is_dest)

    def syntax_determines_value(self) -> bool:
        return True

    def str_to_op_val(self, as_str: str) -> int:
        width, pfx = RegOperandType.TYPE_FMTS[self.reg_type]

        re_pfx = '' if pfx is None else re.escape(pfx)
        match = re.match(re_pfx + '([0-9]+)$', as_str)
        if match is None:
            raise ValueError("Expression {!r} can't be parsed as a {}."
                             .format(as_str, self.reg_type))

        idx = int(match.group(1))
        assert 0 <= idx
        if idx >> width:
            raise ValueError("Invalid register of type {}: {!r}."
                             .format(self.reg_type, as_str))

        return idx

    def op_val_to_str(self, op_val: int, cur_pc: Optional[int]) -> str:
        fmt = RegOperandType.TYPE_FMTS.get(self.reg_type)
        assert fmt is not None
        _, pfx = fmt

        if pfx is None:
            pfx = ''

        return '{}{}'.format(pfx, op_val)

    def is_src(self) -> bool:
        '''True if this operand is considered a source'''
        return self._is_src or self.reg_type in ['csr', 'wsr']

    def is_dest(self) -> bool:
        '''True if this operand is considered a destination'''
        return self._is_dest or self.reg_type in ['csr', 'wsr']


class ImmOperandType(OperandType):
    '''A class representing an immediate operand type'''
    def __init__(self,
                 width: Optional[int],
                 enc_offset: int,
                 shift: int,
                 signed: bool,
                 pc_rel: bool) -> None:
        assert shift >= 0

        super().__init__(width)
        self.enc_offset = enc_offset
        self.shift = shift
        self.signed = signed
        self.pc_rel = pc_rel

    @staticmethod
    def make(width: Optional[int],
             enc_offset: int,
             shift: int,
             signed: bool,
             pc_rel: bool,
             what: str,
             scheme_field: Optional[EncSchemeField]) -> 'ImmOperandType':
        if scheme_field is not None:
            # If there is an encoding scheme, check its width is compatible
            # with the operand type. If the operand type doesn't specify a
            # width, get one from the encoding scheme.
            if width is None:
                width = scheme_field.bits.width
            if scheme_field.bits.width != width:
                raise ValueError('In {}, there is an encoding scheme that '
                                 'allocates {} bits to the immediate operand '
                                 'but the operand claims to have width {}.'
                                 .format(what, scheme_field.bits.width, width))

        return ImmOperandType(width, enc_offset, shift, signed, pc_rel)

    @staticmethod
    def _doc_rel_to_abs(value: int) -> str:
        '''Turn X to . + X or . - X, as appropriate.'''
        if value < 0:
            return '.-{}'.format(-value)
        elif value == 0:
            return '.'
        else:
            return '.+{}'.format(value)

    def markdown_doc(self) -> Optional[str]:
        # Override from OperandType base class
        rng = self.get_doc_range()
        if rng is None:
            return None

        lo, hi = rng
        if self.shift == 0:
            stp_msg = ''
        else:
            stp_msg = ' in steps of `{}`'.format(1 << self.shift)

        rel_suffix = ''
        if self.pc_rel:
            rel_suffix = (' This is encoded PC-relative but appears '
                          'as an absolute value in assembly. To write a raw '
                          'value in an assembly file, write something in the '
                          'range `{}` to `{}`.'
                          .format(ImmOperandType._doc_rel_to_abs(lo),
                                  ImmOperandType._doc_rel_to_abs(hi)))

        return ('Valid range: `{}` to `{}`{}.{}'
                .format(lo, hi, stp_msg, rel_suffix))

    def describe_decode(self, bits_lst: List[str]) -> str:
        # The "most general" result is something like this:
        #
        #   PC + (signed({A, B, C} + enc_offset) << shift)
        #
        # But if enc_offset is zero and shift is positive, we'd like results
        # that look like
        #
        #   PC + signed({A, B, C, 2'b0})

        # Show shift with a concatenation if there is no offset
        shift = self.shift
        if shift and not self.enc_offset:
            bits_lst = bits_lst + ["{}'b0".format(shift)]
            shift = 0

        # Render as a concatenation and make the conversion to an integer
        # explicit.
        xsigned = 'signed' if self.signed else 'unsigned'
        acc = '{}({})'.format(xsigned,
                              OperandType._describe_bits_lst(bits_lst))
        acc_prec = 2

        if self.enc_offset:
            acc = '{} + {}'.format(acc, self.enc_offset)
            if shift:
                # Although a + b << c is logically the same as (a + b) << c, we add
                # the parentheses to make it easier to read.
                acc = '({}) << {}'.format(acc, self.shift)
                acc_prec = 0
        else:
            assert not shift

        if self.pc_rel:
            if acc_prec < 1:
                acc = '({})'.format(acc)

            acc = 'PC + {}'.format(acc)

        return acc

    def str_to_op_val(self, as_str: str) -> Optional[int]:
        # Try to parse the literal as an integer. Give up safely if we can't
        # decipher the immediate here. It might be a label which binutils' as
        # can deal with for us.
        try:
            return int(as_str, 0)
        except ValueError:
            return None

    def op_val_to_str(self, op_val: int, cur_pc: Optional[int]) -> str:
        if self.pc_rel and cur_pc is not None:
            # When we're generating code to be assembled (in the random
            # instruction generator), we need to make write PC-relative
            # addresses as offsets. Otherwise the assembler can't know they'll
            # fit (since *it* doesn't know PC).
            #
            # The other time this is used is objdump, where either version
            # works fine.
            return ImmOperandType._doc_rel_to_abs(op_val - cur_pc)
        else:
            return str(op_val)

    def op_val_to_enc_val(self,
                          op_val: int,
                          cur_pc: Optional[int]) -> Optional[int]:
        # Give up immediately if we don't know our width
        if self.width is None:
            return None

        if self.pc_rel:
            # If the operand is PC-relative and we don't have cur_pc, give up.
            if cur_pc is None:
                return None

            # Otherwise, we need to encode the offset.
            pc_relative_val = op_val - cur_pc
        else:
            pc_relative_val = op_val

        # Try to shift right. Check that we won't clobber any low bits.
        shift_mask = (1 << self.shift) - 1
        if pc_relative_val & shift_mask:
            raise ValueError('Cannot encode the value {}: the operand has a '
                             'shift of {}, but that would clobber some bits '
                             '(because {} & {} = {}, not zero).'
                             .format(pc_relative_val, self.shift,
                                     pc_relative_val, shift_mask,
                                     pc_relative_val & shift_mask))

        # Compute offset encoded value by applying shift and enc_offset
        shifted = pc_relative_val >> self.shift
        offset_val = shifted - self.enc_offset

        # Check offset encoded value sits in the allowable range for encoded
        # values
        enc_rng = self.get_enc_range()
        assert enc_rng is not None
        enc_lo, enc_hi = enc_rng

        if not (enc_lo <= offset_val <= enc_hi):
            doc_rng = self.get_doc_range()
            assert doc_rng is not None
            doc_lo, doc_hi = doc_rng

            encoded_msg = (', which encodes to {},'.format(offset_val)
                           if self.shift != 0 or self.enc_offset != 0 else '')
            raise ValueError('Cannot encode the value {}{} as a {}-bit '
                             '{}signed value. Possible range: {}..{}.'
                             .format(pc_relative_val, encoded_msg,
                                     self.width,
                                     '' if self.signed else 'un',
                                     doc_lo, doc_hi))

        if self.signed:
            encoded = (1 << self.width) + offset_val if offset_val < 0 else offset_val
        else:
            assert offset_val >= 0
            encoded = offset_val

        assert (encoded >> self.width) == 0
        return encoded

    def enc_val_to_op_val(self, enc_val: int, cur_pc: int) -> Optional[int]:
        # If this immediate is signed and we have a valid width, we need to
        # convert the value to a 2's-complement signed number. (There's not
        # much we can do if we don't know our width!)
        signed_val = enc_val
        if self.signed:
            if self.width is None:
                return None

            assert (enc_val >> self.width) == 0
            assert self.width >= 1
            if enc_val >> (self.width - 1):
                signed_val -= 1 << self.width
                assert signed_val < 0

        signed_val += self.enc_offset

        shifted = signed_val << self.shift

        # If this value is PC-relative, add the current PC. The point is that
        # something encoded as "10" means "10 + pc", and is written that way in
        # assembly code. If we don't actually know our current PC, we can write
        # it as ". + <shifted>", but we do better than that if we can.
        rel_val = shifted + (cur_pc if self.pc_rel else 0)

        return rel_val

    def get_enc_range(self) -> Optional[Tuple[int, int]]:
        '''Gets range of allowable encoded values'''
        if self.width is None:
            return None

        if self.signed:
            sgn_lo = -((1 << self.width) // 2)
            sgn_hi = max(-(sgn_lo + 1), 0)
        else:
            sgn_lo = 0
            sgn_hi = (1 << self.width) - 1

        return (sgn_lo, sgn_hi)

    def get_doc_range(self) -> Optional[Tuple[int, int]]:
        '''Gets range of allowable values as they will appear in
        documentation
        '''

        enc_range = self.get_enc_range()
        if enc_range is None:
            return None

        sgn_lo, sgn_hi = enc_range

        sgn_lo += self.enc_offset
        sgn_hi += self.enc_offset

        return (sgn_lo << self.shift, sgn_hi << self.shift)

    def get_op_val_range(self, cur_pc: int) -> Optional[Tuple[int, int]]:
        rel_rng = self.get_doc_range()
        if rel_rng is None:
            return None

        rel_lo, rel_hi = rel_rng
        pc_off = cur_pc if self.pc_rel else 0
        return (rel_lo + pc_off, rel_hi + pc_off)


class EnumOperandType(OperandType):
    '''A class representing an enum operand type

    Enum operands are case-insensitive: the names are stored lower case, and
    are matched with case-folding in read_index.

    '''
    def __init__(self,
                 items: List[str],
                 what: str,
                 scheme_field: Optional[EncSchemeField]) -> None:
        assert items

        # The number of items gives a minimum width for the field. If there is
        # an encoding, use that width, but check that it's enough to hold all
        # the items.
        min_width = int.bit_length(len(items) - 1)
        if scheme_field is None:
            width = min_width
        else:
            if scheme_field.bits.width < min_width:
                raise ValueError('In {}, there is an encoding scheme that '
                                 'assigns {} bits to the field. But this '
                                 'field is an enum with {} items, so needs '
                                 'at least {} bits.'
                                 .format(what, scheme_field.bits.width,
                                         len(items), min_width))
            width = scheme_field.bits.width

        super().__init__(width)
        self.items = [item.lower() for item in items]

    def markdown_doc(self) -> Optional[str]:
        # Override from OperandType base class
        parts = ['| Assembly Syntax | Value |\n'
                 '|-----------------|-------|\n']
        for idx, item in enumerate(self.items):
            parts.append('| `{}` | `{}` |\n'
                         .format(item, idx))
        return ''.join(parts)

    def syntax_determines_value(self) -> bool:
        return True

    def str_to_op_val(self, as_str: str) -> int:
        low_str = as_str.lower()
        for idx, item in enumerate(self.items):
            if low_str == item:
                return idx

        known_vals = ', '.join(repr(item) for item in self.items)
        raise ValueError('Invalid enum value, {!r}. '
                         'Supported values: {}.'
                         .format(as_str, known_vals))

    def op_val_to_str(self, op_val: int, cur_pc: Optional[int]) -> str:
        # On a bad value, we have to return *something*. Since this is just
        # going into disassembly, let's be vaguely helpful and return something
        # that looks clearly bogus.
        #
        # Note that if the number of items in the enum is not a power of 2,
        # this could happen with a bad binary, despite good tools.
        if op_val < 0 or op_val >= len(self.items):
            return '???'

        return self.items[op_val]

    def get_max_enc_val(self) -> int:
        return len(self.items) - 1


class OptionOperandType(OperandType):
    '''A class representing an option operand type

    Option operands are case-insensitive: the option name is stored lower case,
    and is matched with case-folding in read_index.

    '''
    def __init__(self,
                 option: str,
                 what: str,
                 scheme_field: Optional[EncSchemeField]) -> None:

        width = 1
        if scheme_field is not None:
            assert width <= scheme_field.bits.width
            width = scheme_field.bits.width

        super().__init__(width)
        self.option = option.lower()

    def markdown_doc(self) -> Optional[str]:
        # Override from OperandType base class
        return 'To specify, use the literal syntax `{}`\n'.format(self.option)

    def syntax_determines_value(self) -> bool:
        return True

    def str_to_op_val(self, as_str: str) -> int:
        if as_str.lower() == self.option:
            return 1

        raise ValueError('Invalid option value, {!r}. '
                         'If specified, it should have been {!r}.'
                         .format(as_str, self.option))

    def op_val_to_str(self, op_val: int, cur_pc: Optional[int]) -> str:
        assert op_val in [0, 1]
        return self.option if op_val else ''

    def get_max_enc_val(self) -> int:
        return 1


def parse_operand_type(fmt: str,
                       pc_rel: bool,
                       what: str,
                       scheme_field: Optional[EncSchemeField]) -> OperandType:
    '''Make sense of the operand type syntax'''
    # Registers
    reg_fmts = {
        'grs': ('gpr', True, False),
        'grd': ('gpr', False, True),
        'wrs': ('wdr', True, False),
        'wrd': ('wdr', False, True),
        'wrb': ('wdr', True, True),
    }
    reg_match = reg_fmts.get(fmt)
    if reg_match is not None:
        if pc_rel:
            raise ValueError('In {}, the operand has type {!r} which is a '
                             'type of register operand. It also has pc_rel '
                             'set, which is only allowed for immediates.'
                             .format(what, fmt))
        reg_type, is_src, is_dest = reg_match
        return RegOperandType.make(reg_type, is_src, is_dest, what, scheme_field)

    # CSR and WSR indices. These are treated like unsigned immediates, with
    # width 12 and 8, respectively.
    xsr_fmts = {
        'csr': 12,
        'wsr': 8
    }
    xsr_match = xsr_fmts.get(fmt)
    if xsr_match is not None:
        assert not pc_rel
        return ImmOperandType.make(xsr_match, 0, 0, False, False,
                                   what, scheme_field)

    # Immediates
    for base, signed in [('simm', True), ('uimm', False)]:
        # The type of an immediate operand is encoded as
        #
        #   BASE WIDTH? (+ENC_OFFSET)? (<<SHIFT)?
        #
        # where BASE is 'simm' or 'uimm', WIDTH is a positive integer and
        # ENC_OFFSET and SHIFT are non-negative integers. The regex below
        # captures WIDTH as group 1, OFFSET as group 2 and SHIFT as group 3.
        m = re.match(base + r'([1-9][0-9]*)?(?:\+([0-9]+))?(?:<<([0-9]+))?$', fmt)
        if m is not None:
            width = int(m.group(1)) if m.group(1) is not None else None
            enc_offset = int(m.group(2)) if m.group(2) is not None else 0
            shift = int(m.group(3)) if m.group(3) is not None else 0
            return ImmOperandType.make(width, enc_offset, shift, signed, pc_rel,
                                       what, scheme_field)

    m = re.match(r'enum\(([^\)]+)\)$', fmt)
    if m:
        if pc_rel:
            raise ValueError('In {}, the operand is an enumeration, but also '
                             'has pc_rel set, which is only allowed for bare '
                             'immediates.'
                             .format(what))

        return EnumOperandType([item.strip()
                                for item in m.group(1).split(',')],
                               what, scheme_field)
    m = re.match(r'option\(([^\)]+)\)$', fmt)
    if m:
        if pc_rel:
            raise ValueError('In {}, the operand is an option, but also '
                             'has pc_rel set, which is only allowed for bare '
                             'immediates.'
                             .format(what))

        return OptionOperandType(m.group(1).strip(), what, scheme_field)

    raise ValueError("In {}, operand type description {!r} "
                     "didn't match any recognised format."
                     .format(what, fmt))


def infer_operand_type(name: str,
                       pc_rel: bool,
                       what: str,
                       scheme_field: Optional[EncSchemeField]) -> OperandType:
    '''Try to guess an operand's type from its name'''

    op_type_name = None
    if re.match(r'grs[0-9]*$', name):
        op_type_name = 'grs'
    elif name in ['grd', 'wrd', 'csr', 'wsr']:
        op_type_name = name
    elif re.match(r'wrs[0-9]*$', name):
        op_type_name = 'wrs'
    elif re.match(r'imm[0-9]*$', name) or name == 'offset':
        op_type_name = 'simm'

    if op_type_name is None:
        raise ValueError("Operand name {!r} doesn't imply an operand type: "
                         "you'll have to set the type explicitly."
                         .format(name))

    return parse_operand_type(op_type_name, pc_rel, what, scheme_field)


def make_operand_type(op_type_name: Optional[str],
                      pc_rel: bool,
                      operand_name: str,
                      mnemonic: str,
                      scheme_field: Optional[EncSchemeField]) -> OperandType:
    '''Construct a type for an operand

    This is either based on the type, if given, or inferred from the name
    otherwise. If scheme_field is not None, this is the encoding scheme field
    that will be used.

    '''
    what = ('the type for the {!r} operand of instruction {!r}'
            .format(operand_name, mnemonic))
    return (parse_operand_type(op_type_name, pc_rel, what, scheme_field)
            if op_type_name is not None
            else infer_operand_type(operand_name, pc_rel, what, scheme_field))


class Operand:
    def __init__(self,
                 yml: object,
                 mnemonic: str,
                 insn_encoding: Optional[Encoding]) -> None:
        # The YAML representation should be a string (a bare operand name) or a
        # dict.
        what = 'operand for {!r} instruction'.format(mnemonic)
        if isinstance(yml, str):
            name = yml.lower()
            abbrev = None
            op_type = None
            doc = None
            pc_rel = False
            op_what = '{!r} {}'.format(name, what)
        elif isinstance(yml, dict):
            yd = check_keys(yml, what,
                            ['name'],
                            ['type', 'pc-rel', 'doc', 'abbrev'])
            name = check_str(yd['name'], 'name of ' + what).lower()

            op_what = '{!r} {}'.format(name, what)
            abbrev = get_optional_str(yd, 'abbrev', op_what)
            if abbrev is not None:
                abbrev = abbrev.lower()
            op_type = get_optional_str(yd, 'type', op_what)
            pc_rel = check_bool(yd.get('pc-rel', False),
                                'pc-rel field of ' + op_what)
            doc = get_optional_str(yd, 'doc', op_what)

        # If there is an encoding, look up the encoding scheme field that
        # corresponds to this operand.
        enc_scheme_field = None
        if insn_encoding is not None:
            field_name = insn_encoding.op_to_field_name.get(name)
            if field_name is None:
                raise ValueError('The {!r} instruction has an operand called '
                                 '{!r}, but the associated encoding has no '
                                 'field that encodes it.'
                                 .format(mnemonic, name))
            enc_scheme_field = insn_encoding.fields[field_name].scheme_field

        if abbrev is not None:
            if name == abbrev:
                raise ValueError('Operand {!r} of the {!r} instruction has '
                                 'an abbreviated name the same as its '
                                 'actual name.'
                                 .format(name, mnemonic))
        self.name = name
        self.abbrev = abbrev
        self.op_type = make_operand_type(op_type, pc_rel, name,
                                         mnemonic, enc_scheme_field)
        self.doc = doc
