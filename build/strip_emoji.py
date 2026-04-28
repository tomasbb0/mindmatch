#!/usr/bin/env python3
"""Strip emojis and decorative symbols from a markdown file before PDF rendering."""
import re
import sys

EMOJI_PATTERN = re.compile(
    "["
    "\U0001F1E0-\U0001F1FF"
    "\U0001F300-\U0001F5FF"
    "\U0001F600-\U0001F64F"
    "\U0001F680-\U0001F6FF"
    "\U0001F700-\U0001F77F"
    "\U0001F780-\U0001F7FF"
    "\U0001F800-\U0001F8FF"
    "\U0001F900-\U0001F9FF"
    "\U0001FA00-\U0001FA6F"
    "\U0001FA70-\U0001FAFF"
    "\U00002600-\U000026FF"
    "\U00002700-\U000027BF"
    "\U0001F018-\U0001F270"
    "\U0000FE00-\U0000FE0F"
    "\U00002B00-\U00002BFF"
    "\U000023E9-\U000023FA"
    "]+",
    flags=re.UNICODE,
)

def strip(text: str) -> str:
    text = EMOJI_PATTERN.sub("", text)
    # Collapse multiple spaces left behind
    text = re.sub(r"  +", " ", text)
    # Remove orphan spaces at line start after emoji removal
    text = re.sub(r"^\s+# ", "# ", text, flags=re.MULTILINE)
    text = re.sub(r"^# +", "# ", text, flags=re.MULTILINE)
    text = re.sub(r"^## +", "## ", text, flags=re.MULTILINE)
    text = re.sub(r"^### +", "### ", text, flags=re.MULTILINE)
    text = re.sub(r"^- +", "- ", text, flags=re.MULTILINE)
    text = re.sub(r"\| +", "| ", text)
    return text

if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        out = strip(f.read())
    with open(dst, "w", encoding="utf-8") as f:
        f.write(out)
    print(f"Stripped: {src} -> {dst}")
