#!/usr/bin/env bash

set -euo pipefail

tmpImg=$(mktemp /tmp/ocrSnip-XXXXXX.png)

geometry=$(slurp)
[ -z "$geometry" ] && exit 1

grim -g "$geometry" "$tmpImg"

ocrText=$(tesseract "$tmpImg" - 2>/dev/null | sed '/^\s*$/d')

if [ -z "$ocrText" ]; then
    notify-send "OCR Snip" "No text detected"
    rm -f "$tmpImg"
    exit 1
fi

echo -n "$ocrText" | wl-copy

notify-send "OCR Snip" "Text copied to clipboard"

rm -f "$tmpImg"
