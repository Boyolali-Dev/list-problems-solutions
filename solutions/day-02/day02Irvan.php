<?php

class Solution
{

  /**
   * @param String $s
   * @param String $t
   * @return Boolean
   */
  function isAnagram($s, $t)
  {
    if (strlen($s) !== strlen($t)) {
      return false;
    }

    // Convert both strings to lowercase, split into characters, sort, and compare
    $sArray = str_split(strtolower($s));
    $tArray = str_split(strtolower($t));

    sort($sArray);
    sort($tArray);

    return $sArray === $tArray;
  }
}