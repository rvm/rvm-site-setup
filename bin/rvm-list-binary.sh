#!/usr/bin/env bash

base_path="/home/rvm/shared/public/binaries"
base_url="https://rvm.io/binaries"

cd "$base_path"

function display_file()
{
  typeset type="$1"
  while
    read path
  do
    path="${path#./}"
    case "${type:-}" in
      (md5)    path="$path=$( md5sum    "$path" | awk '{print $1}' )" ;;
      (sha512) path="$path=$( sha512sum "$path" | awk '{print $1}' )" ;;
    esac
    echo "$base_url/$path"
  done < <(
    find . -type f -name '*.tar.bz2' | grep -v experimental | sort -n
  )
}

case $# in
  (0)
    types=( remote md5 sha512 )
    ;;
  (1)
    display_file $1
    types=()
    ;;
  (*)
    types=( $@ )
    ;;
esac

for type in "${types[@]}"
do
  echo "--- config/$type"
  display_file "$type"
done
