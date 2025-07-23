func containsDuplicate(nums []int) bool {
	res := make(map[int]bool)
	for _, x := range nums {
		if res[x] {
			return true
		}
		res[x] = true
	}
	return false
}