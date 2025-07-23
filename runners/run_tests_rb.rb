require 'json'

if ARGV.length != 2
  puts "Usage: ruby run_tests_rb.rb <testfile.json> <solution.rb>"
  exit 1
end

testfile, solution_file = ARGV

# Load the solution file
require_relative "../#{solution_file}"

# Read and parse the test cases
tests = JSON.parse(File.read(testfile))

pass_count = 0
fail_count = 0

tests.each_with_index do |test, idx|
  input = test["input"]
  expected = test["expected"]

  begin
    result = solve(input)
    if result == expected
      puts "✅ Test #{idx + 1}: Passed"
      pass_count += 1
    else
      puts "❌ Test #{idx + 1}: Failed"
      puts "   Input: #{input.inspect}"
      puts "   Expected: #{expected.inspect}"
      puts "   Got: #{result.inspect}"
      fail_count += 1
    end
  rescue => e
    puts "💥 Test #{idx + 1}: Error - #{e}"
    fail_count += 1
  end
end

puts "\nSummary: #{pass_count} passed, #{fail_count} failed, #{tests.size} total"
exit(fail_count > 0 ? 1 : 0)