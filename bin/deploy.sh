#!/usr/bin/env bash

base_path="/home/rvm/site"
base_url="https://github.com/rvm/rvm-site.git"
release_marker="$( date +%s )"

source /usr/local/rvm/scripts/rvm

cd "$base_path"

mkdir -p shared releases

if
  [[ -d shared/clone/.git ]]
then
  (
    cd shared/clone
    git remote set-url origin $base_url
    git pull
  )
else
  if [[ -d shared/clone ]]
  then rm -rf shared/clone
  fi
  git clone $base_url shared/clone
fi

cp -r shared/clone releases/$release_marker &&
cd releases/$release_marker &&
bundle install &&
bundle exec nanoc compile &&
ln -nfs "$base_path/releases/$release_marker" "$base_path/current" ||
rm -rf  "$base_path/releases/$release_marker"
