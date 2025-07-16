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
                for attr_name in dir(solution):
                    if not attr_name.startswith('_'):
                        attr = getattr(solution, attr_name)
                        if callable(attr):
                            # Check if it's the method we want (containsDuplicate for day01)
                            if 'containsDuplicate' in attr_name or 'contains' in attr_name.lower():
                                method_name = attr_name
                                break
                
                if not method_name:
                    # Try to find any method that matches the input structure
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