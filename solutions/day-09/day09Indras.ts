export default function isPalindrome(s: string): boolean {
  let i = 0;
  let j = s.length - 1;

  function isAlphanumericChar(char: string): boolean {
    const code = char.charCodeAt(0);
    return (
      (code >= 48 && code <= 57) || // 0-9
      (code >= 65 && code <= 90) || // A-Z
      (code >= 97 && code <= 122) // a-z
    );
  }

  while (i < j) {
    const left = s[i];
    const right = s[j];

    if (!isAlphanumericChar(left)) {
      i++;
      continue;
    }
    if (!isAlphanumericChar(right)) {
      j--;
      continue;
    }

    if (left.toLowerCase() !== right.toLowerCase()) {
      return false;
    }

    i++;
    j--;
  }

  return true;
}
