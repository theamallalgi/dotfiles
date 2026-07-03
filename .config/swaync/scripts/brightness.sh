#!/usr/bin/env bash

getBrightness() {
  brightnessctl -m | awk -F, '{print substr($4,1,length($4)-1)}'
}

case "$1" in
  up)   brightnessctl set 5%+ ;;
  down) brightnessctl set 5%- ;;
esac

val=$(getBrightness)

notify-send -a "osd" -h string:x-canonical-private-synchronous:osd \
  -h int:value:"$val" -t 1500 "" ""
