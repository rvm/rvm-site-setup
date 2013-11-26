# rvm-site-setup

Setup fo <http://rvm.io>:

## Getting to server

1. checkout to `~/site`

## Nginx

1. run once `bin/site-check.sh`
1. copy `conf/nginx.rb` to `/etc/nginx/sites-available/rvm.io` and set IP addresses
1. add `bin/site-check.sh` to cron (example in file)

## Irc bot

1. put password for `smf_bot` in `smfbot/.password`
1. `rvm alias create cinch ruby-2.0.0-p353@cinch`
1. copy `conf/smfbot.conf` to `$HOME/.config/upstart/smfbot.conf`
1. edit `/etc/dbus-1/system.d/Upstart.conf` and copy second section for `rvm` user
1. start the irc bot: `initctl start smfbot`
