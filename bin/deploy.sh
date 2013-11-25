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
    builtin cd shared/clone
    git remote set-url origin $base_url
    git pull
  )
else
  if [[ -d shared/clone ]]
  then rm -rf shared/clone
  fi
  git clone $base_url shared/clone
fi

copy_public_from_cache()
{
  if [[ -d shared/public-cache ]]
  then cp -r shared/public-cache releases/$release_marker/public || return $?
  fi
}

copy_public_to_cache()
{
  rsync -a $base_path/releases/$release_marker/public $base_path/shared/public-cache || return $?
}

cp -r shared/clone releases/$release_marker &&
copy_public_from_cache &&
cd releases/$release_marker &&
gem install --file Gemfile &&
NOEXEC_DISABLE=1 RUBYGEMS_GEMDEPS=- nanoc compile &&
copy_public_to_cache &&
ln -nfs "$base_path/releases/$release_marker" "$base_path/current" &&
echo "success!" ||
{
  typeset result=$?
  rm -rf  "$base_path/releases/$release_marker"
  echo failed:$result
  exit $result
}
