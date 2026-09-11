#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="/run/media/amal/Windows/Users/Amal/Videos/Television/Series"

show=$(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort | fzf --prompt="Series > ")
[[ -z "$show" ]] && exit 0

mapfile -t episodes < <(find "$BASE_DIR/$show" -type f \( -iname '*.mkv' -o -iname '*.mp4' \) | sort -V)

start=$(printf '%s\n' "${episodes[@]}" | fzf --prompt="Start from > " --with-nth=-1 -d/)
[[ -z "$start" ]] && exit 0

start_idx=0
for i in "${!episodes[@]}"; do
	[[ "${episodes[$i]}" == "$start" ]] && start_idx=$i && break
done

mpv --no-terminal "${episodes[@]:$start_idx}"
