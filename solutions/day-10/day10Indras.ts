export default function twoSum(numbers: number[], target: number): number[] {
  let i = 0;
  let j = numbers.length - 1;

  while (i < j) {
    const currentTotal = numbers[i] + numbers[j];
    if (currentTotal > target) {
      j--;
    } else if (currentTotal < target) {
      i++;
    } else {
      return [i + 1, j + 1];
    }
  }

  return [];
}
