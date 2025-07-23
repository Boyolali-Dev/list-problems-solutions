from collections import Counter
from typing import List

class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        
        n = Counter(nums)

        top = []
        
        for n in n.most_common(k):
            top.append(n[0])

        return top