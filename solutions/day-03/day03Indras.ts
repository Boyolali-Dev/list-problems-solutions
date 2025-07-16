export default function twoSum(nums: number[], target: number): number[] {
  const map: Map<number, number> = new Map();

  for (let i = 0; i < nums.length; i++) {
    const currentValue = nums[i];
    const diff = target - currentValue;

    if (map.has(diff)) {
      return [map.get(diff)!, i];
    }

    map.set(currentValue, i);
  }

  return [];
}
