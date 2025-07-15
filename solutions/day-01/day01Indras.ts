function containsDuplicate(nums: number[]): boolean {
  const numberSet = new Set<number>();

  for (let num of nums) {
    if (numberSet.has(num)) {
      return true;
    }

    numberSet.add(num);
  }

  return false;
}
