package day03

func twoSum(nums []int, target int) []int {
	res := make(map[int]int)
	for i, v := range nums {
		if _, ok := res[v]; ok {

			return []int{i, res[v]}
		}
		res[target-v] = i

	}
	return []int{}
}
