from simple_test import find_tests, helper_test_count
import os, py
from typing import Any
from pathlib import Path
import numpy as np
import random
import copy
import secrets
from ctypes import c_int16, c_int32

def test_fn(tmpdir: py.path.local,
               asm_file: str,
               expected_file: str) -> None:
    assert helper_test_count(tmpdir=tmpdir, asm_file=asm_file, expected_file=expected_file)


def array_to_hex(arr):
    # Ensure the array has 8 elements for a 256-bit register
    if len(arr) != 8:
        raise ValueError("Array must contain exactly 8 elements.")

    hex_str = ''
    for num in arr:
        # Handle 2's complement for negative numbers
        if num < 0:
            num = (1 << 32) + num
        hex_part = hex(num)[2:].rjust(8, '0')
        hex_str = hex_part + hex_str

    return hex_str


def bnvecmul_prototype(arr1, arr2):
    # Vectorized Multiply of low 16 bits of each 32-bit lane to give a 32-bit result
    if len(arr1) != 8 or len(arr2) != 8:
        raise ValueError("Both arrays must contain 8 elements.")
    
    result = []
    for a, b in zip(arr1, arr2):
        print("a:\t" + str(a) + "\tb:\t" + str(b)) 
        result.append(c_int32((c_int16(a).value) * (c_int16(b).value)).value)
    return result


def bnvecmul32_prototype(arr1, arr2):
    # Vectorized Multiply of full 32 bits of each 32-bit lane, truncated to give a 32-bit result
    if len(arr1) != 8 or len(arr2) != 8:
        raise ValueError("Both arrays must contain 8 elements.")
    
    result = []
    for a, b in zip(arr1, arr2):
        print("a:\t" + str(a) + "\tb:\t" + str(b)) 
        result.append(c_int32((c_int32(a).value) * (c_int32(b).value)).value)
    return result


def bnvecadd_prototype(arr1, arr2):
    # Performs a vectorized addition on each 16-bit lane of the two source WDRs.
    if len(arr1) != 8 or len(arr2) != 8:
        raise ValueError("Both arrays must contain 8 elements.")
    
    result = [((a & 0xFFFF) + (b & 0xFFFF) & 0xFFFF) for a, b in zip(arr1, arr2)]
    return result


def bnvecsub_prototype(arr1, arr2):
    # Performs a vectorized subtraction between each 16-bit lane of the two source WDRs.
    if len(arr1) != 8 or len(arr2) != 8:
        raise ValueError("Both arrays must contain 8 elements.")
    
    result = [(((a & 0xFFFF) - (b & 0xFFFF)) & 0xFFFF) for a, b in zip(arr1, arr2)]
    return result


def bnrshiftvec_prototype(arr, shift_amount):
    # Perfrms a vectorized logical right shift on each 32-bit lane of a WDR
    if len(arr) != 8:
        raise ValueError("The array must contain 8 elements.")

    if not (0 <= shift_amount <= 31):
        raise ValueError("Shift amount must be between 0 and 31.")

    result = [(a >> shift_amount) for a in arr]
    return result


def bnlshiftvec_prototype(arr, shift_amount):
    # Perfrms a vectorized left shift on each 32-bit lane of a WDR
    if len(arr) != 8:
        raise ValueError("The array must contain 8 elements.")

    if not (0 <= shift_amount <= 31):
        raise ValueError("Shift amount must be between 0 and 31.")

    result = [((a << shift_amount) & 0xFFFFFFFF) for a in arr]
    return result


def bnlshi_prototype(register_value, shift_amount):
    # Shift the contents of a WDR to the left by a specified number of bits.
    if not (0 <= shift_amount <= 255):
        raise ValueError("Shift amount must be between 0 and 255.")

    result = (register_value << shift_amount) & ((1 << 256) - 1)

    return result


def generate_random_int16_arrays():
    # Generates a pair of random 16-bit arrays with 8 elements each

    # Define the range for 16-bit integers
    min_val, max_val = -32768, 32767
    
    array1 = [random.randint(min_val, max_val) for _ in range(8)]
    array2 = [random.randint(min_val, max_val) for _ in range(8)]
    
    return (array1, array2)


def generate_random_int32_array():
    # Define the range for 32-bit integers
    min_val, max_val = -2147483648, 2147483647
    
    # Generate a list of 8 random 32-bit integers
    array = [random.randint(min_val, max_val) for _ in range(8)]
    return array


def create_tests_bnvecmul(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = dirpath +  "/template.s"
    exp_template_path = dirpath + "/template.exp"

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = dirpath + '/inputoutput'
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template = asm_template.read()
        exp_template = exp_template.read()

        # Create the input files
        for i in range(len(inputs)):
            
            input = inputs[i]
            result = bnvecmul_prototype(input[0], input[1])
            out = array_to_hex(result)
            tmpcopy = asm_template
            # Write the input value into the template
            tmpreplace = tmpcopy.replace("[inp1]", generate_otbn_data_section_32bit_from16(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", generate_otbn_data_section_32bit_from16(input[1]))
            # Create a new file for this input
            new_asm_filepath = inputoutputpath + "/test" + str(i) + ".s"
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

            tmpcopy = exp_template

            tmpreplace = tmpcopy.replace("[out]", "0x" + str(out))
            tmpreplace = tmpreplace.replace("[inp1]", "0x" + array_to_hex(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", "0x" + array_to_hex(input[1]))
            
            # Create a new file for this output
            new_exp_filepath = inputoutputpath + "/test" + str(i) + ".exp"
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

    return find_tests("test_bnvecmul/inputoutput")


def create_tests_bnvecmul32(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = dirpath +  "/template.s"
    exp_template_path = dirpath + "/template.exp"

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = dirpath + '/inputoutput'
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template = asm_template.read()
        exp_template = exp_template.read()

        # Create the input files
        for i in range(len(inputs)):
            
            input = inputs[i]
            result = bnvecmul32_prototype(input[0], input[1])
            out = array_to_hex(result)
            tmpcopy = asm_template
            # Write the input value into the template
            tmpreplace = tmpcopy.replace("[inp1]", generate_otbn_data_section_32bit_from16(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", generate_otbn_data_section_32bit_from16(input[1]))
            # Create a new file for this input
            new_asm_filepath = inputoutputpath + "/test" + str(i) + ".s"
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

            tmpcopy = exp_template

            tmpreplace = tmpcopy.replace("[out]", "0x" + str(out))
            tmpreplace = tmpreplace.replace("[inp1]", "0x" + array_to_hex(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", "0x" + array_to_hex(input[1]))
            
            # Create a new file for this output
            new_exp_filepath = inputoutputpath + "/test" + str(i) + ".exp"
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

    return find_tests("test_bnvecmul32/inputoutput")


def create_tests_bnvecadd(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = dirpath +  "/template.s"
    exp_template_path = dirpath + "/template.exp"

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = dirpath + '/inputoutput'
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template = asm_template.read()
        exp_template = exp_template.read()

        # Create the input files
        for i in range(len(inputs)):
            
            input = inputs[i]
            result = bnvecadd_prototype(input[0], input[1])
            out = array_to_hex(result)
            tmpcopy = asm_template
            # Write the input value into the template
            tmpreplace = tmpcopy.replace("[inp1]", generate_otbn_data_section_32bit_from16(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", generate_otbn_data_section_32bit_from16(input[1]))
            # Create a new file for this input
            new_asm_filepath = inputoutputpath + "/test" + str(i) + ".s"
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

            tmpcopy = exp_template

            tmpreplace = tmpcopy.replace("[out]", "0x" + str(out))
            tmpreplace = tmpreplace.replace("[inp1]", "0x" + array_to_hex(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", "0x" + array_to_hex(input[1]))
            
            # Create a new file for this output
            new_exp_filepath = inputoutputpath + "/test" + str(i) + ".exp"
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

    return find_tests("test_bnvecadd/inputoutput")


def create_tests_bnvecsub(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = dirpath +  "/template.s"
    exp_template_path = dirpath + "/template.exp"

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = dirpath + '/inputoutput'
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template = asm_template.read()
        exp_template = exp_template.read()

        # Create the input files
        for i in range(len(inputs)):
            
            input = inputs[i]
            result = bnvecsub_prototype(input[0], input[1])
            out = array_to_hex(result)
            tmpcopy = asm_template
            # Write the input value into the template
            tmpreplace = tmpcopy.replace("[inp1]", generate_otbn_data_section_32bit_from16(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", generate_otbn_data_section_32bit_from16(input[1]))
            # Create a new file for this input
            new_asm_filepath = inputoutputpath + "/test" + str(i) + ".s"
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

            tmpcopy = exp_template

            tmpreplace = tmpcopy.replace("[out]", "0x" + str(out))
            tmpreplace = tmpreplace.replace("[inp1]", "0x" + array_to_hex(input[0]))
            tmpreplace = tmpreplace.replace("[inp2]", "0x" + array_to_hex(input[1]))
            
            # Create a new file for this output
            new_exp_filepath = inputoutputpath + "/test" + str(i) + ".exp"
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

    return find_tests("test_bnvecsub/inputoutput")


def create_tests_bnvecrshift(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = os.path.join(dirpath, "template.s")
    exp_template_path = os.path.join(dirpath, "template.exp")

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = os.path.join(dirpath, 'inputoutput')
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template_content = asm_template.read()
        exp_template_content = exp_template.read()

        # Create the input files
        for i, input in enumerate(inputs):
            arr = input[0]
            shift_amount = input[1]

            result = bnrshiftvec_prototype(arr, shift_amount)
            out = array_to_hex(result)  

            asm_replaced = asm_template_content.replace("[inp1]", generate_otbn_data_section_32bit_from16(arr))
            asm_replaced = asm_replaced.replace("[inp2]", str(shift_amount))

            new_asm_filepath = os.path.join(inputoutputpath, f"test{i}.s")
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(asm_replaced)

            exp_replaced = exp_template_content.replace("[out]", "0x" + out)
            exp_replaced = exp_replaced.replace("[inp]", "0x" + array_to_hex(arr))

            new_exp_filepath = os.path.join(inputoutputpath, f"test{i}.exp")
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(exp_replaced)

    return find_tests(os.path.join("test_bnrshiftvec", "inputoutput"))


def create_tests_bnveclshift(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = os.path.join(dirpath, "template.s")
    exp_template_path = os.path.join(dirpath, "template.exp")

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = os.path.join(dirpath, 'inputoutput')
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template_content = asm_template.read()
        exp_template_content = exp_template.read()

        # Create the input files
        for i, input in enumerate(inputs):
            arr = input[0]
            shift_amount = input[1]

            result = bnlshiftvec_prototype(arr, shift_amount)
            out = array_to_hex(result)

            asm_replaced = asm_template_content.replace("[inp1]", generate_otbn_data_section_32bit_from16(arr))
            asm_replaced = asm_replaced.replace("[inp2]", str(shift_amount))

            new_asm_filepath = os.path.join(inputoutputpath, f"test{i}.s")
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(asm_replaced)

            exp_replaced = exp_template_content.replace("[out]", "0x" + out)
            exp_replaced = exp_replaced.replace("[inp]", "0x" + array_to_hex(arr))

            new_exp_filepath = os.path.join(inputoutputpath, f"test{i}.exp")
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(exp_replaced)

    return find_tests(os.path.join("test_bnlshiftvec", "inputoutput"))


def register_value_to_hex(value):
    """
    Convert a 256-bit register value to a hex string.
    """
    return format(value & (2**256 - 1), '064x')


def create_tests_reg_lshift(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = os.path.join(dirpath, "template.s")
    exp_template_path = os.path.join(dirpath, "template.exp")

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = os.path.join(dirpath, 'inputoutput')
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template_content = asm_template.read()
        exp_template_content = exp_template.read()

        for i, (register_value, shift_amount) in enumerate(inputs):
            # Shift the register contents
            result = bnlshi_prototype(register_value, shift_amount)

            out_hex = register_value_to_hex(result)

            asm_replaced = asm_template_content.replace("[inp1]", generate_otbn_data_section_64bit(register_value))
            asm_replaced = asm_replaced.replace("[inp2]", str(shift_amount))

            new_asm_filepath = os.path.join(inputoutputpath, f"test{i}.s")
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(asm_replaced)

            exp_replaced = exp_template_content.replace("[out]", "0x" + out_hex)
            exp_replaced = exp_replaced.replace("[inp]", "0x" + register_value_to_hex(register_value))

            new_exp_filepath = os.path.join(inputoutputpath, f"test{i}.exp")
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(exp_replaced)

    return find_tests(os.path.join("test_bnlshi", "inputoutput"))


def create_tests_bnvecbroadcast(dirpath, inputs):
    # Read in the input and output templates
    asm_template_path = os.path.join(dirpath, "template.s")
    exp_template_path = os.path.join(dirpath, "template.exp")

    # Create an /inputoutput directory if it does not already exist
    inputoutputpath = os.path.join(dirpath, 'inputoutput')
    if not os.path.exists(inputoutputpath):
        os.makedirs(inputoutputpath)

    with open(asm_template_path, 'r') as asm_template, open(exp_template_path, 'r') as exp_template:
        asm_template_content = asm_template.read()
        exp_template_content = exp_template.read()

        # Create the input files
        for i, input_val in enumerate(inputs):
            # replicate the input value across all 8 lanes
            result = [input_val for _ in range(8)]
            out = array_to_hex(result)

            tmpreplace = asm_template_content.replace("[inp]", generate_otbn_data_section_32bit_from16([input_val]))
            
            # Create a new file for this input
            new_asm_filepath = os.path.join(inputoutputpath, f"test{i}.s")
            with open(new_asm_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

            tmpreplace = exp_template_content.replace("[out]", "0x" + out)
            
            # Create a new file for this output
            new_exp_filepath = os.path.join(inputoutputpath, f"test{i}.exp")
            with open(new_exp_filepath, 'w') as newfile:
                newfile.write(tmpreplace)

    return find_tests(os.path.join("test_bnvecbroadcast", "inputoutput"))


def generate_random_256bit_number():
    # 256 bits = 32 bytes. secrets.token_bytes generates a random byte string.
    # int.from_bytes converts a byte string into an integer.
    random_number = int.from_bytes(secrets.token_bytes(32), 'big')
    return random_number


def pytest_generate_tests(metafunc: Any) -> None:
    if metafunc.function is test_fn:
        tests = list()

        input_pairs_32b_arrays = []

        input_pairs_16b_arrays = []

        shift_inps = []

        broadcast_inps = []

        bnlshi_prototype_inputs = []
        
        for i in range(100):
            el1, el2 = generate_random_int32_array(), generate_random_int32_array()
            array16a, array16b = generate_random_int16_arrays()
            input_pairs_16b_arrays.append([array16a, array16b])
            input_pairs_32b_arrays.append([el1, el2])
            shift_inps.append([generate_random_int32_array(), random.randint(0, 17)])
            broadcast_inps.append(random.randint(0, 0xFFFF))
            bnlshi_prototype_inputs.append([generate_random_256bit_number(), random.randint(1, 128)])
        
        # Create all of the input/output files in the /testadd directory
        # tests += create_tests_bnvecmul32("test/test_bnvecmul", input_pairs_32b_arrays)
        #tests += create_tests_bnvecmul("test/test_bnvecmul", input_pairs_32b_arrays)
        #tests += create_tests_bnvecadd("test/test_bnvecadd", input_pairs_16b_arrays)
        #tests += create_tests_bnvecsub("test/test_bnvecsub", input_pairs_16b_arrays)
        #tests += create_tests_bnvecrshift("test/test_bnrshiftvec", shift_inps)
        #tests += create_tests_bnveclshift("test/test_bnlshiftvec", shift_inps)
        #tests += create_tests_bnvecbroadcast("test/test_bnvecbroadcast", broadcast_inps)
        #tests += create_tests_reg_lshift("test/test_bnlshi", bnlshi_prototype_inputs)
            
        test_ids = [os.path.basename(e[0]) for e in tests]
        metafunc.parametrize("asm_file,expected_file", tests, ids=test_ids)


def generate_otbn_data_section_32bit_from16(values):
    """
    Generates the .data section for OTBN assembly where each 16-bit value
    is stored in a 32-bit word in memory, ensuring that the array's elements
    are in order of increasing significance in memory locations. Each 16-bit value
    is placed in the lower 16 bits of a 32-bit word, with the upper 16 bits padded with zeroes.
    This is done to make the process of reading array elements into 32-bit registers
    easier. If there is only one value every 32-bits, then no manipulation in the
    GPRs is required. This approach is only for testing of individual instructions,
    not used in the actual algorithmic tests.
    """
    vals = copy.deepcopy(values)
    # Initialize the assembly code string
    assembly_code = ".data\n"

    required_words = 8
    padding_required = required_words - len(vals)
    
    # Pad with zeroes if necessary to reach 256 bits
    vals.extend([0] * padding_required)

    for val in vals:
        # Convert to two's complement if negative
        if val < 0:
            val = ((~(-val) + 1) & 0xFFFF)
        else:
            val = val & 0xFFFF

        assembly_code += f"    .word 0x{val:08x}\n"
        
    return assembly_code

def generate_otbn_data_section_64bit(value_256bit):
    """
    Generates the .data section for OTBN assembly from a single 256-bit value,
    storing it as four 64-bit double words (dwords) in memory. The 256-bit value
    is split into four 64-bit chunks, with each chunk stored in increasing order
    of significance in memory locations.
    """
    # Initialize the assembly code string
    assembly_code = ".data\n"

    for i in range(4):
        chunk = (value_256bit >> (64 * i)) & 0xFFFFFFFFFFFFFFFF
        assembly_code += f"    .dword 0x{chunk:016x}\n"
        
    return assembly_code
