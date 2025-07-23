<?php

    class Solution {

        /**
         * @param Integer[] $numbers
         * @param Integer $target
         * @return Integer[]
         */
        function twoSum($numbers, $target): array|null {
            $checked = [];

            for($i = 1; $i <= count($numbers); $i++){
                $currentValue = $numbers[$i -1];
                $complement = $target - $currentValue;

                if(isset($checked[$complement])){
                    return [$checked[$complement], $i];
                }

                $checked[$currentValue] = $i;
            }
            return null;
        }
    }
?>