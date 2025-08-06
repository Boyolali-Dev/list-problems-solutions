class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        anagram_map = defaultdict(list)

        for word in strs:
            # Sort the word and use it as a key
            key = ''.join(sorted(word))
            anagram_map[key].append(word)

        # Return all grouped anagrams
        return list(anagram_map.values())