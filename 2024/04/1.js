const fs = require('fs');
const path = require('path');

const file = fs.readFileSync(path.join(__dirname, 'data.txt'), 'utf8');
const lines = file.split(/\r?\n/);

function hasWordInDirection(startX, startY, dirX, dirY) {
    if (dirX === 0 && dirY === 0) {
        return false;
    }
    const chars = []
    chars[0] = lines[startY][startX];
    for (let i = 1; i < 4; i++) {
        const y = startY + dirY * i;
        const x = startX + dirX * i;
        if (y < 0 || y >= lines.length || x < 0 || x >= lines[0].length) {
            return false; // Array OOB
        }
        chars[i] = lines[y][x];
    }
    return chars.join("") === "XMAS"
}

let sum = 0
for (let y = 0; y < lines.length; y++) {
    for (let x = 0; x < lines[0].length; x++) {
        const char = lines[y][x];
        if (char === "X") {
            for (let dirY = -1; dirY <= 1; dirY++) {
                for (let dirX = -1; dirX <= 1; dirX++) {
                    sum += hasWordInDirection(x, y, dirX, dirY) ? 1 : 0;
                }
            }
        }
    }
}