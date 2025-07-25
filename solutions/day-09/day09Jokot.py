import string

class Solution:
    def isPalindrome(self, s: str) -> bool:
        translator = str.maketrans("","", string.punctuation)
        s = s.translate(translator)
        s = s.lower()
        s = s.replace(" ", "")

        return s == s[::-1]
