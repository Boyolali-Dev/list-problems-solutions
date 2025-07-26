export default function maxArea(height: number[]): number {
  let max = 0;
  let i = 0;
  let j = height.length - 1;

  while (i < j) {
    const currentMinHeight = height[i] < height[j] ? i : j;
    const currentMaxArea = height[currentMinHeight] * (j - i);

    max = max > currentMaxArea ? max : currentMaxArea;

    if (currentMinHeight === i) {
      i++;
    } else if (currentMinHeight === j) {
      j--;
    }
  }

  return max;
}
