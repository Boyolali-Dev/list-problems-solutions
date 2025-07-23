#!/usr/bin/env python3

import sys
import json
import importlib.util
from pathlib import Path

def load_solution_module(sol_file_path):
    """Dynamically load a Python solution module"""
    spec = importlib.util.spec_from_file_location("solution", sol_file_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def main():
    # Get CLI arguments: test file and solution file
    if len(sys.argv) != 3:
        print("Usage: python run_tests_py.py <test_file> <solution_file>")
        sys.exit(1)
    
    test_file = sys.argv[1]
    sol_file = sys.argv[2]
    
    # Read and parse the test case JSON
    with open(test_file, 'r') as f:
        cases = json.load(f)
    
    # Dynamically load the solution file
    try:
        solution_module = load_solution_module(sol_file)
        solution = solution_module.Solution()
    except Exception as e:
        print(f"❌ Failed to load solution from {sol_file}: {e}")
        sys.exit(1)
    
    # Run each test case
    for i, case in enumerate(cases):
        try:
            # Get the method name from the first test case
            if i == 0:
                # Find the method that takes the input parameters
                method_name = None
                input_keys = list(case['input'].keys())
                
                # First, try to find the main method by common patterns
                for attr_name in dir(solution):
                    if not attr_name.startswith('_'):
                        attr = getattr(solution, attr_name)
                        if callable(attr):
                            # Check for common main method patterns
                            if any(pattern in attr_name.lower() for pattern in ['topkfrequent', 'groupanagrams', 'containsduplicate', 'validpalindrome', 'twosum']):
                                method_name = attr_name
                                break
                
                # If no main method found, try to find method by parameter names
                if not method_name:
                    for attr_name in dir(solution):
                        if not attr_name.startswith('_'):
                            attr = getattr(solution, attr_name)
                            if callable(attr):
                                # Check if method name matches any input key or common patterns
                                if any(key in attr_name.lower() for key in input_keys):
                                    method_name = attr_name
                                    break
                                # Check for common method patterns
                                elif any(pattern in attr_name.lower() for pattern in ['group', 'anagram', 'duplicate', 'valid', 'palindrome']):
                                    method_name = attr_name
                                    break
                
                if not method_name:
                    # Fallback: find any public method
                    for attr_name in dir(solution):
                        if not attr_name.startswith('_'):
                            attr = getattr(solution, attr_name)
                            if callable(attr):
                                method_name = attr_name
                                break
                
                if not method_name:
                    print(f"❌ Could not find appropriate method in {sol_file}")
                    sys.exit(1)
            
            # Call the method with input parameters
            input_values = list(case['input'].values())
            actual = getattr(solution, method_name)(*input_values)
            expected = case['expected']
            
            # Compare results
            ok = actual == expected
            
            if not ok:
                print(f"❌ {sol_file} failed on case {i}")
                print(f"   Input: {json.dumps(case['input'])}")
                print(f"   Expected: {json.dumps(expected)}")
                print(f"   Got: {json.dumps(actual)}")
                sys.exit(1)
                
        except Exception as e:
            print(f"❌ {sol_file} failed on case {i} with error: {e}")
            print(f"   Input: {json.dumps(case['input'])}")
            sys.exit(1)
    
    print(f"✅ {sol_file} passed {len(cases)} test cases")

if __name__ == "__main__":
    main() 