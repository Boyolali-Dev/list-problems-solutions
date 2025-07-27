var isValidSudokuBoard = function(board) {
    const column = Array.from({ length: 9 }, () => new Set());
    const box = Array.from({ length: 9 }, () => new Set());

    for (let i = 0; i < 9; i++) {
        const row = new Set();
        for (let j = 0; j < 9; j++) {
            const cell = board[i][j];
            if (cell !== '.') {
                if (row.has(cell) || column[j].has(cell) || box[Math.floor(i / 3) * 3 + Math.floor(j / 3)].has(cell)) {
                    return false;
                }
                row.add(cell);
                column[j].add(cell);
                box[Math.floor(i / 3) * 3 + Math.floor(j / 3)].add(cell);
            }
        }
    }

    return true;
};