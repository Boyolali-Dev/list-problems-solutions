export default function topKFrequent(nums: number[], k: number): number[] {
  const count: { [key: number]: number } = {};
  let maxFreq = 0;

  // Step 1: Count frequency of each number
  for (let num of nums) {
    count[num] = (count[num] || 0) + 1;
    if (count[num] > maxFreq) {
      maxFreq = count[num];
    }
  }

  const freq: number[][] = Array.from({ length: maxFreq + 1 }, () => []);

  for (let key in count) {
    const frequency = count[key];
    freq[frequency].push(Number(key));
  }

  const res: number[] = [];
  for (let i = freq.length - 1; i >= 0; i--) {
    for (let val of freq[i]) {
      res.push(val);
      if (res.length === k) {
        return res;
      }
    }
  }

  return res;
}
