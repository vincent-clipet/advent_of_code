const fs = require('fs');
const path = require('path');

const file = fs.readFileSync(path.join(__dirname, 'data.txt'), 'utf8');
const line = file.split(/\r?\n/).join("");
const pattern = /mul\(\d{1,3},\d{1,3}\)/g
const matches = line.matchAll(pattern);

let sum = 0
for (const match of matches) {
    sum += match[0].slice(4, match[0].length - 1).split(",").map(e => Number(e)).reduce((a, b) => a * b);
}
console.log(`Sum = ${sum}`)