#!/usr/bin/env -S ts-node --esm
import fs from "fs";
import { pathToFileURL } from "url";

const [, , testFile, solFile] = process.argv;
const cases = JSON.parse(fs.readFileSync(testFile, "utf8"));
const { default: solution } = await import(pathToFileURL(solFile));
cases.forEach((c, i) => {
  const ok =
    JSON.stringify(solution(...Object.values(c.input))) ===
    JSON.stringify(c.expected);
  if (!ok) throw new Error(`${solFile} ❌ case ${i}`);
});
console.log(`${solFile} ✅ ${cases.length} cases`);
