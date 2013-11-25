#!/usr/bin/env bash

# > crontab -l
# * * * * * bash /home/rvm/site/bin/site-check.sh github https://github.com/wayneeseguin/rvm.git

if
  curl --head --max-time 1 --fail $2 >/dev/null 2>&1
then
  touch $HOME/$1-is-running
  rm -f $HOME/$1-not-running
else
  rm -f $HOME/$1-is-running
  touch $HOME/$1-not-running
fi
