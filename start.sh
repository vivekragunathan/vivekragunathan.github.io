#!/usr/bin/env bash

if ! pagefind --version > /dev/null 2>&1; then
  echo >&2 "Error: pagefind not found!"
  exit 1
else
  hugo --gc --cleanDestinationDir \
    && pagefind --site public \
    && hugo server --disableFastRender -p 51234
fi
