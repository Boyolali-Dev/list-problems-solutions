from collections import defaultdict

class Solution:
    def groupAnagrams(self, strs: list[str]) -> list[list[str]]:

        mapGroup = defaultdict(list)

        for s in strs:
            key = self.createMapKey(s)
            mapGroup[key].append(s)
        
        return list(mapGroup.values())
            
    def createMapKey(self, str1):
        key = [0] * 26

        for c in str1:
            key[ord(c) - ord('a')] += 1
        
        return tuple(key)
