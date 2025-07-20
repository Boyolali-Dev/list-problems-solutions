var isAnagram = function(s, t) {
    if (s.length !== t.length) return false;

    const count = {};

    for (const char of s) {
        count[char] = (count[char] || 0) + 1;
    }

    for (const char of t) {
        if (!count[char]) return false; 
        count[char]--;
    }

    return true;
};