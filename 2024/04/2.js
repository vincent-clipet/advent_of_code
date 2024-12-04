const fs = require('fs');
const path = require('path');

const file = fs.readFileSync(path.join(__dirname, 'data.txt'), 'utf8');
const lines = file.split(/\r?\n/);

function isCross(centerX, centerY) {
    if (centerX === 0 || centerX === lines[0].length -1 || centerY === 0 || centerY === lines.length - 1) {
        return false; // Array OOB
    }

    const diag1 = lines[centerY-1][centerX-1] + lines[centerY][centerX] + lines[centerY+1][centerX+1]; // NW -> SE
    const diag2 = lines[centerY-1][centerX+1] + lines[centerY][centerX] + lines[centerY+1][centerX-1]; // NE -> SW

    return ((diag1 === "MAS" || diag1 === "SAM") && (diag2 === "MAS" || diag2 === "SAM"));
}

let sum = 0
for (let y = 0; y < lines.length; y++) {
    for (let x = 0; x < lines[0].length; x++) {
        const char = lines[y][x];
        if (char === "A") {
            sum += isCross(x, y) ? 1 : 0;
        }
    }
}
console.log(sum)