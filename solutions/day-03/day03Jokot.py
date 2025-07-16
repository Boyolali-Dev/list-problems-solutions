class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        seen = {}

        for i, n in enumerate(nums):
            left = target - n
            if left in seen:
                return [seen[left], i]
            seen[n] = i
        
        return []
