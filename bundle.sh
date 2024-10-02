#!/usr/bin/env bash

log () {
  echo >&2 "$1"
}

emptyFolder() {
  local dest_folder="$1"
  shift
  local exclude_folders=("$@")

  # Enables the dotglob shell option, which allows the script
  # to include hidden files and folders (those starting with
  # a dot) in the file expansion.
  shopt -s dotglob

  for item in "$dest_folder"/*; do
    local exclude=false
    for folder in "${exclude_folders[@]}"; do
      if [[ "$item" == "$dest_folder/$folder" ]]; then
        exclude=true
        break
      fi
    done

    if ! $exclude; then
      rm -rf "$item"
    fi
  done
}

if [ -z "$1" ]; then
  log "Error: Destination folder not provided."
  log "Usage: $0 </path/to/copy/bundle/to/>"
  exit 1
fi

SRC_FOLDER="./public/"
DEST_FOLDER="$1"

emptyFolder "$DEST_FOLDER" ".git" ".gitignore" ".gitkeep"
mkdir -p "$DEST_FOLDER"
cp -r "$SRC_FOLDER"/. "$DEST_FOLDER"
