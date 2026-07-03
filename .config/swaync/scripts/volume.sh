#!/usr/bin/env bash

getVol() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2 * 100}'
}

case "$1" in
  up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
  down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
  mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

val=$(getVol)

notify-send -a "osd" -h string:x-canonical-private-synchronous:osd \
  -h int:value:"$val" -t 1500 "" ""
