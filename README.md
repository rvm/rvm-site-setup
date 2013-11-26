# rvm-site-setup

Setup fo <http://rvm.io>:

1. checkout to `~/site`
2. copy `conf/nginx.rb` to `/etc/nginx/sites-available/rvm.io` and set IP addresses
3. put password for `smf_bot` in `smfbot/.password`
4. copy `conf/smfbot.conf` to `$HOME/.config/upstart/smfbot.conf`
5. `rvm alias create cinch ruby-2.0.0-p353@cinch`
