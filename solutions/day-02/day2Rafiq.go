
// isAnagram checks if two strings are anagrams of each other.
func isAnagram(s string, t string) bool {
	if len(s) != len(t) {
		return false
	}
	count := make(map[rune]int)

	for _, x := range s {
		count[x]++
	}
	for _, x := range t {
		count[x] -= 1
		if count[x] < 0 {
			return false
		}
	}
	return true
}
