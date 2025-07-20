<?php

if ($argc !== 3) {
  echo "Usage: php run_tests_php.php <testfile.json> <solution.php>\n";
  exit(1);
}

$testfile = $argv[1];
$solution_file = $argv[2];

require_once __DIR__ . "/../$solution_file";

$tests = json_decode(file_get_contents($testfile), true);

$pass_count = 0;
$fail_count = 0;

foreach ($tests as $idx => $test) {
  $input = $test["input"];
  $expected = $test["expected"];

  try {
    $solution = new Solution();
    // For isAnagram, expects $s and $t as input
    if (isset($input["s"]) && isset($input["t"])) {
      $result = $solution->isAnagram($input["s"], $input["t"]);
    } else {
      throw new Exception("Input must have 's' and 't' keys");
    }

    if ($result === $expected) {
      echo "✅ Test " . ($idx + 1) . ": Passed\n";
      $pass_count++;
    } else {
      echo "❌ Test " . ($idx + 1) . ": Failed\n";
      echo "   Input: " . json_encode($input) . "\n";
      echo "   Expected: " . var_export($expected, true) . "\n";
      echo "   Got: " . var_export($result, true) . "\n";
      $fail_count++;
    }
  } catch (Throwable $e) {
    echo "💥 Test " . ($idx + 1) . ": Error - " . $e->getMessage() . "\n";
    $fail_count++;
  }
}

echo "\nSummary: $pass_count passed, $fail_count failed, " . count($tests) . " total\n";
exit($fail_count > 0 ? 1 : 0);
