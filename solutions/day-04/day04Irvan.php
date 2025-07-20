<?php

class Solution
{

  /**
   * @param String[] $strs
   * @return String[][]
   */
  function groupAnagrams($strs)
  {
    $anagramMap = [];

    foreach ($strs as $word) {
      $sorted = str_split($word);
      sort($sorted);
      $key = implode('', $sorted); // use sorted word as key

      $anagramMap[$key][] = $word;
    }

    return array_values($anagramMap);
  }
}
