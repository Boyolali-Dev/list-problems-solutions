export default function productExceptSelf(nums: number[]): number[] {
  let zeroCount = 0;
  let totalProduct = 1;

  for (const num of nums) {
    if (num === 0) {
      zeroCount++;
      if (zeroCount > 1) break;
    } else {
      totalProduct *= num;
    }
  }

  return nums.map((num) => {
    if (zeroCount > 1) return 0;
    if (zeroCount === 1) return num === 0 ? totalProduct : 0;
    return totalProduct / num;
  });
}
