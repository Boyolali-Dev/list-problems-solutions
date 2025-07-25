export default function isValidSudoku(board: string[][]): boolean {
  const columns: Set<string>[] = Array.from({ length: 9 }, () => new Set());
  const boxes: Set<string>[] = Array.from({ length: 9 }, () => new Set());

  for (let i = 0; i < 9; i++) {
    const row = new Set<string>();
    for (let j = 0; j < 9; j++) {
      const val = board[i][j];
      if (val === ".") continue;

      if (row.has(val)) return false;
      row.add(val);

      if (columns[j].has(val)) return false;
      columns[j].add(val);

      const boxIndex = Math.floor(i / 3) * 3 + Math.floor(j / 3);
      if (boxes[boxIndex].has(val)) return false;
      boxes[boxIndex].add(val);
    }
  }

  return true;
}
