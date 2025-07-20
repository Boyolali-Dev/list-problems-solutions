<?php
class Solution
{

  /**
   * @param int[] $nums
   * @param int $k
   * @return int[]
   */
  function topKFrequent($nums, $k)
  {
    $frequencyMap = [];

    // Count frequency of each number
    foreach ($nums as $num) {
      if (!isset($frequencyMap[$num])) {
        $frequencyMap[$num] = 0;
      }
      $frequencyMap[$num]++;
    }

    // Sort the frequency map by frequency descending
    arsort($frequencyMap);

    // Get the top k frequent elements
    return array_slice(array_keys($frequencyMap), 0, $k);
  }
}
