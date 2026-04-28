#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/tomasbatalha/Projects/Code Repos/mindmatch"
OUT="$HOME/Desktop/MindMatch_Print"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

QR_URL='mailto:tomasmbatalha@gmail.com?subject=MindMatch%20Early%20Access%20-%20NovaSBE%20Showcase&body=Hi%20MindMatch%21%0D%0A%0D%0AI%27d%20love%20early%20access%20when%20you%20launch%20in%20Lisbon.%0D%0A%0D%0AName%3A%20%0D%0AInitials%20%28matches%20my%20card%29%3A%20%0D%0AWhat%20brought%20me%20to%20your%20booth%3A%20%0D%0A%0D%0AThanks%21'

DISPLAY_URL="Opens your mail app when you scan"

cd "$ROOT"

echo "==> QR target: $QR_URL"
QR_URL="$QR_URL" python3 - <<'PY'
import os, qrcode
url = os.environ["QR_URL"]
qr = qrcode.QRCode(version=None, box_size=18, border=2,
                   error_correction=qrcode.constants.ERROR_CORRECT_M)
qr.add_data(url)
qr.make(fit=True)
img = qr.make_image(fill_color="#1a1f36", back_color="white")
img.save("build/qr.png")
print("QR saved size:", img.size, "encoded url length:", len(url))
PY

echo "==> Building poster html..."
sed "s|{{QR_URL}}|$DISPLAY_URL|g" build/qr_poster.html > build/qr_poster_final.html

echo "==> Rendering PDF..."
"$CHROME" --headless --disable-gpu --no-pdf-header-footer --virtual-time-budget=2000 \
  --print-to-pdf="$OUT/04_QR_SIGNUP_POSTER.pdf" \
  "file://$ROOT/build/qr_poster_final.html"

ls -lh "$OUT/04_QR_SIGNUP_POSTER.pdf"
open "$OUT/04_QR_SIGNUP_POSTER.pdf"
