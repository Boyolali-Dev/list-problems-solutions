<?php

class Solution
{

  /**
   * @param int[] $nums
   * @param int $target
   * @return int[]
   */
  function twoSum($nums, $target)
  {
    $map = []; // value => index
    foreach ($nums as $i => $num) {
      $complement = $target - $num;
      if (isset($map[$complement])) {
        return [$map[$complement], $i];
      }

      $map[$num] = $i;
    }

    // Based on problem constraints, we assume exactly one solution
    return [];
  }
}