var longestConsecutive = function(nums) {
    const setup = new Set(nums);
    let longestStreak = 0;
    for (const num of setup) {
        if (!setup.has(num - 1)) {
            let currentNum = num;
            let currentStreak = 1;

            while (setup.has(currentNum + 1)) {
                currentNum++;
                currentStreak++;
            }

            longestStreak = Math.max(longestStreak, currentStreak);
        }
    }

    return longestStreak;
};