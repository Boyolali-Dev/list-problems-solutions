export default function groupAnagrams(strs: string[]): string[][] {
  const map: Map<string, string[]> = new Map();
  const charAtStart = "a".charCodeAt(0);

  for (const str of strs) {
    const count = new Array(26).fill(0);

    for (const ch of str) {
      count[ch.charCodeAt(0) - charAtStart]++;
    }

    const key = count.join(",");

    if (!map.has(key)) {
      map.set(key, [str]);
    } else {
      map.get(key)?.push(str);
    }
  }

  return Array.from(map.values());
}
