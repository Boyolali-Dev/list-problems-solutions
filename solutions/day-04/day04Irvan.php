<?php

class Solution
{

  /**
   * @param String[] $strs
   * @return String[][]
   */
  function groupAnagrams($strs)
  {
    $map = [];

    foreach ($strs as $str) {
      // Initialize frequency count for a-z
      $count = array_fill(0, 26, 0);

      // Count characters
      for ($i = 0; $i < strlen($str); $i++) {
        $index = ord($str[$i]) - ord('a');
        if ($index >= 0 && $index < 26) {
          $count[$index]++;
        }
      }

      // Use joined count as key
      $key = implode(',', $count);

      // Group strings with the same character frequency
      if (!isset($map[$key])) {
        $map[$key] = [];
      }
      $map[$key][] = $str;
    }

    return array_values($map);
  }
}
