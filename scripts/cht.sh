#!/usr/bin/env bash

# NOTE: Usage: cht golang:slice
# cht python:reverse a list
# cht golang "slice append"

set -euo pipefail

query="$*"

if [[ "$query" == *:* ]]; then
    lang="${query%%:*}"
    topic="${query#*:}"
else
    lang="${1:-}"
    shift || true
    topic="$*"
fi

if [[ -z "$lang" || -z "$topic" ]]; then
    echo "Usage: cht <lang>:<query>  or  cht <lang> <query>"
    exit 1
fi

topic="${topic// /+}"

response=$(curl -sS "cht.sh/${lang}/${topic}")

if [[ "$response" == *"<!doctype html>"* || "$response" == *"Internal Server Error"* ]]; then
    echo "Error: '$lang' is not a recognized cht.sh language/topic, or the query is malformed."
    exit 1
fi

echo "$response" | less -R
