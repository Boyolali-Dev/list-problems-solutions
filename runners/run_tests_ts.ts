#!/usr/bin/env ts-node

import fs from "fs";
import path from "path";

// Get CLI arguments: test file and solution file
const [, , testFile, solFile] = process.argv;

// Read and parse the test case JSON
const cases = JSON.parse(fs.readFileSync(testFile, "utf8"));

// Dynamically load the solution file
const solution = require(path.resolve(solFile)).default;

// Run each test case
cases.forEach((c: any, i: number) => {
  const actual = solution(...Object.values(c.input));
  const expected = c.expected;

  const ok = JSON.stringify(actual) === JSON.stringify(expected);

  if (!ok) {
    console.error(`❌ ${solFile} failed on case ${i}`);
    console.error(`   Input: ${JSON.stringify(c.input)}`);
    console.error(`   Expected: ${JSON.stringify(expected)}`);
    console.error(`   Got: ${JSON.stringify(actual)}`);
    process.exit(1);
  }
});

console.log(`✅ ${solFile} passed ${cases.length} test cases`);
