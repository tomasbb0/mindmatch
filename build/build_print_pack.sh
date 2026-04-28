#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/tomasbatalha/Projects/Code Repos/mindmatch"
OUT="$HOME/Desktop/MindMatch_Print"
QR_URL="${QR_URL:-https://mindmatch.pt/waitlist}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

cd "$ROOT"
mkdir -p "$OUT"

echo "==> QR ($QR_URL)"
python3 - <<PY
import qrcode
qr = qrcode.QRCode(version=None, box_size=20, border=2,
                   error_correction=qrcode.constants.ERROR_CORRECT_M)
qr.add_data("$QR_URL")
qr.make(fit=True)
img = qr.make_image(fill_color="#1a1f36", back_color="white")
img.save("build/qr.png")
print("QR saved")
PY

echo "==> Stripping emojis"
python3 build/strip_emoji.py SHOWCASE_CHEATSHEET.md build/cheatsheet.md
python3 build/strip_emoji.py IN_EVENT_PLAYBOOK.md build/playbook.md

echo "==> Substituting QR URL"
sed "s|{{QR_URL}}|$QR_URL|g" build/qr_poster.html > build/qr_poster_final.html

echo "==> MD -> HTML"
pandoc build/cheatsheet.md -s --css=print.css -o build/cheatsheet.html \
  --metadata title="MindMatch - Showcase Cheat Sheet"
pandoc build/playbook.md -s --css=print.css -o build/playbook.html \
  --metadata title="MindMatch - In-Event Playbook"

echo "==> Rendering PDFs"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/01_SHOWCASE_CHEATSHEET.pdf" \
  "file://$ROOT/build/cheatsheet.html"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/02_IN_EVENT_PLAYBOOK.pdf" \
  "file://$ROOT/build/playbook.html"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/03_CARD_SORT.pdf" \
  "file://$ROOT/build/cards.html"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/04_QR_SIGNUP_POSTER.pdf" \
  "file://$ROOT/build/qr_poster_final.html"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/05_FIT_ANXIETY_WALL.pdf" \
  "file://$ROOT/build/wall_header.html"
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT/06_EVIDENCE_HANDOUT.pdf" \
  "file://$ROOT/EVIDENCE_HANDOUT.html"

echo "==> Done."
ls -lh "$OUT"
