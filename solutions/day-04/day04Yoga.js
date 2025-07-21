var groupAnagrams = function(strs) {
    const map = {};

    for (const word of strs) {
        const freq = new Array(26).fill(0);

        for (const char of word) {
            freq[char.charCodeAt(0) - 97]++; 
        }

        const key = freq.join(';'); 

        if (!map[key]) {
            map[key] = [];
        }
        map[key].push(word);
    }

    return Object.values(map);
};
