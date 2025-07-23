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
    // loop nums to define frequency each number
    $frequencyMap = [];
    foreach ($nums as $num) {
      $frequencyMap[$num] = ($frequencyMap[$num] ?? 0) + 1;
    }

    // Bucket sort: frequency => list of numbers (group by frequency)
    $bucket = [];
    foreach ($frequencyMap as $num => $freq) {
      $bucket[$freq][] = $num;
    }

    $result = [];
    // Traverse buckets from high to low frequency
    for ($i = count($nums); $i > 0 && count($result) < $k; $i--) {
      if (!empty($bucket[$i])) {
        foreach ($bucket[$i] as $num) {
          $result[] = $num;
          if (count($result) === $k) break;
        }
      }
    }
    return $result;
  }
}
