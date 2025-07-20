class Solution {
    fun twoSum(nums: IntArray, target: Int): IntArray {
        val seen = HashMap<Int,Int>()

        nums.forEachIndexed { i, num ->
            val left = target - num
            if (seen.containsKey(left)) return intArrayOf(seen[left]!!, i)
            seen[num] = i
        }

        return intArrayOf()
    }
}