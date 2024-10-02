#!/usr/bin/env bash

# export PAGEFIND_PATH="$HOME/DevTools/pagefind"

if [ ! -n "$PAGEFIND_PATH" ]; then
  echo >&2 "PAGEFIND_PATH env. var is not set! pagefind=https://pagefind.app"
  exit 1
elif [ ! -x "$PAGEFIND_PATH" ]; then
  echo >&2 "PAGEFIND_PATH env. var does not point to an executable!"
  exit 2
else
  hugo --gc --cleanDestinationDir \
    && "$PAGEFIND_PATH" --site public \
    && hugo server --disableFastRender -p 51234
fi
