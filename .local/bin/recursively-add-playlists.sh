#!/bin/sh
updatePlaylists() {
  [ "$(basename "$1")" = "." ] && exit

  if [ -d "$1" ]; then
    for item in $1/*; do
      updatePlaylists "$item" $2
    done
  else
    playlist="$2/$(basename $(dirname "$1"))"
    if grep -q "$1" $playlist; then
      return
    fi

    echo "$1" >> "$playlist"
  fi
}

updatePlaylists $1 $2
