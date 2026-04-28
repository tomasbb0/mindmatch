#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/tomasbatalha/Projects/Code Repos/mindmatch"
OUT="$HOME/Desktop/MindMatch_Print"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

QR_URL="${QR_URL:-https://tomasbb0.github.io/mindmatch/waitlist.html}"

cd "$ROOT"
mkdir -p "$OUT"

echo "==> QR target: $QR_URL"
QR_URL="$QR_URL" python3 - <<'PY'
import os, qrcode
url = os.environ["QR_URL"]
qr = qrcode.QRCode(version=None, box_size=20, border=2,
                   error_correction=qrcode.constants.ERROR_CORRECT_H)
qr.add_data(url)
qr.make(fit=True)
img = qr.make_image(fill_color="#1a1f36", back_color="white")
img.save("build/qr_sticker.png")
print("QR saved size:", img.size, "url:", url)
PY

cat > build/qr_stickers.html <<HTML
<!doctype html>
<html><head><meta charset="utf-8"><title>MindMatch QR stickers</title>
<style>
@page { size: A4; margin: 10mm; }
* { box-sizing: border-box; }
body { margin: 0; font-family: -apple-system, "Helvetica Neue", Arial, sans-serif; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 6mm; }
.sticker {
  border: 1px dashed #aaa;
  padding: 4mm;
  text-align: center;
  page-break-inside: avoid;
}
.sticker img { width: 55mm; height: 55mm; display: block; margin: 0 auto; }
.sticker .label {
  font-size: 9pt; color: #1a1f36; margin-top: 3mm;
  font-weight: 600; letter-spacing: 0.3px;
}
.sticker .url {
  font-size: 7pt; color: #555; margin-top: 1mm;
  word-break: break-all;
}
</style></head>
<body>
<div class="grid">
HTML

for i in $(seq 1 9); do
  cat >> build/qr_stickers.html <<HTML
  <div class="sticker">
    <img src="qr_sticker.png" alt="QR">
    <div class="label">SCAN → MindMatch</div>
    <div class="url">$QR_URL</div>
  </div>
HTML
done

cat >> build/qr_stickers.html <<HTML
</div>
</body></html>
HTML

echo "==> Rendering sticker sheet PDF..."
"$CHROME" --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=2000 \
  --print-to-pdf="$OUT/07_QR_OVERLAY_STICKERS.pdf" \
  "file://$ROOT/build/qr_stickers.html"

ls -lh "$OUT/07_QR_OVERLAY_STICKERS.pdf"
open "$OUT/07_QR_OVERLAY_STICKERS.pdf"
