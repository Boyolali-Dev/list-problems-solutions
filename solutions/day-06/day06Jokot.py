class Solution:
    def productExceptSelf(self, nums: list[int]) -> list[int]:
        size = len(nums)
        output = [1] * size

        for i in range(1, size):
            output[i] = nums[i-1] * output[i-1]
        
        temp_suffix = 1
        for i in range(size-1, -1, -1):
            output[i] *= temp_suffix
            temp_suffix *= nums[i]

        return output