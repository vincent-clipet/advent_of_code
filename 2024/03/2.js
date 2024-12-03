const fs = require('fs');
const path = require('path');

const file = fs.readFileSync(path.join(__dirname, 'data.txt'), 'utf8');
const line = file.split(/\r?\n/).join("");
const pattern = /(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/g
const matches = line.matchAll(pattern);

let sum = 0
let processData = true

for (const match of matches) {
    if (match[0] === "don't()") {
        processData = false
    } else if (match[0] === "do()") {
        processData = true
    } else if (processData) {
        sum += match[0].slice(4, match[0].length - 1).split(",").map(e => Number(e)).reduce((a, b) => a * b);
    }
}
console.log(`Sum = ${sum}`)