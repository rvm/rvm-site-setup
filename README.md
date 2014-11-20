# rvm-site-setup

Setup for <http://rvm.io>:

## Getting to server

1. checkout to `~/site`

## Nginx

1. run once `bin/site-check.sh`
1. copy `conf/nginx.rb` to `/etc/nginx/sites-available/rvm.io` and set IP addresses
1. add `bin/site-check.sh` to cron (example in file)

## Irc bot

1. put password for `smf_bot` in `smfbot/.password`
1. `rvm alias create cinch ruby-2.0.0-p353@cinch`
1. `rvm wrapper ruby-2.0.0-p353@cinch --no-links smfbot`
1. copy `conf/smfbot.rc` to `/etc/init.d/smfbot`
1. start it first: `sudo service start smfbot`
1. make it autostart later `sudo update-rc.d smfbot defaults`
