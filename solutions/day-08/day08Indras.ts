export default function longestConsecutive(nums: number[]): number {
  const map = new Map();
  let res = 0;
  for (let num of nums) {
    if (!map.has(num)) {
      const left = map.get(num - 1) || 0;
      const right = map.get(num + 1) || 0;
      const total = left + right + 1;

      map.set(num, total);
      map.set(num - left, total);
      map.set(num + right, total);

      res = Math.max(res, total);
    }
  }
  return res;
}
