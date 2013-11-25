#!/usr/bin/env bash

base_path="/home/rvm/site"
base_url="https://github.com/rvm/rvm-site.git"
release_marker="$( date +%s )"

source /usr/local/rvm/scripts/rvm

mkdir -p "$base_path/shared" "$base_path/releases"

if
  [[ -d "$base_path/shared/clone/.git" ]]
then
  (
    builtin cd "$base_path/shared/clone"
    git remote set-url origin "$base_url"
    git pull
  )
else
  if [[ -d "$base_path/shared/clone" ]]
  then rm -rf "$base_path/shared/clone"
  fi
  git clone "$base_url" "$base_path/shared/clone"
fi

link_shared_public()
{
  typeset f
  for f in "$base_path/shared/public"/*
  do ln -nfs "$f" "$base_path/releases/$release_marker/public/" || return $?
  done
}

cp -r "$base_path/shared/clone" "$base_path/releases/$release_marker" &&
cd "$base_path/releases/$release_marker" &&
gem install --file Gemfile &&
NOEXEC_DISABLE=1 RUBYGEMS_GEMDEPS=- nanoc compile &&
link_shared_public &&
ln -nfs "$base_path/releases/$release_marker" "$base_path/current" &&
echo "success!" ||
{
  typeset result=$?
  rm -rf  "$base_path/releases/$release_marker"
  echo failed:$result
  exit $result
}
