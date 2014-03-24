#!/usr/bin/env bash

base_path="/home/rvm/site/shared/public/binaries"

function link_binaries()
{
  typeset file path platform
  for file in "$1"/*/*.tar.bz2
  do
    platform="${file%/*}"
    platform="${platform##*/}"
    file="${file##*/}"

    for path in *
    do
      # do not link to itself
      if [[ "$1" == "$path" ]]
      then continue
      fi
      # link exists already
      if [[ "$path/$platform/$file" -ef "$1/$platform/$file" ]]
      then continue
      fi
      # ensure path exist
      mkdir -p "$path/$platform"
      # remove old files
      if [[ -e "$path/$platform/$file" ]]
      then rm -f "$path/$platform/$file"
      fi
      # link
      ln -v "$1/$platform/$file" "$path/$platform/$file"
    done
  done
}

if
  [[ -n "${1:-}" ]]
then
  cd "$base_path/${1}"
  echo "Linking $1 binaries:"
  link_binaries "${2}"
else
  echo "Usage: $0 <system> <version>" 2>&1
  exit 1
fi
