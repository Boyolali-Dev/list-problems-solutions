var topKFrequent = function(nums, k) {
    const freqMap = {};

    for (const num of nums) {
        freqMap[num] = (freqMap[num] || 0) + 1;
    }

    const buckets = Array(nums.length + 1).fill().map(() => []);

    for (const num in freqMap) {
        const freq = freqMap[num];
        buckets[freq].push(Number(num));
    }

    const result = [];
    for (let i = buckets.length - 1; i >= 0 && result.length < k; i--) {
        if (buckets[i].length > 0) {
            result.push(...buckets[i]);
        }
    }

    return result.slice(0, k);
};
