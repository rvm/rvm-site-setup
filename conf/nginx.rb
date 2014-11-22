log_format simple '$remote_addr - $http_x_forwarded_for - $http_referer - [$time_local] "$request" $status $body_bytes_sent - $host';

server {
  ssl_certificate     /etc/nginx/ssl/star.rvm.io.crt;
  ssl_certificate_key /etc/nginx/ssl/star.rvm.io.key;
  ssl_session_timeout 5m;
  ssl_ciphers "AES256+EECDH:AES256+EDH";
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;
  add_header Strict-Transport-Security "max-age=63072000; includeSubDomains";
  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;
  ssl_stapling on
  ssl_stapling_verify on

  client_max_body_size 20M;
  lingering_close on;
  lingering_time 10;
  tcp_nodelay on;
  sendfile on;
  tcp_nopush off;

  access_log /var/log/nginx/access.log simple;
  error_log  /var/log/nginx/error.log info;

  listen []:443 ssl;
  listen []:80;
  listen :443 ssl;
  listen :80;

  server_name rvm.io *.rvm.io;
  root /home/rvm/site/current/public;

  if ( -f /home/rvm/github-is-running  ) { set $get_url https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer ; }
  if ( -f /home/rvm/github-not-running ) { set $get_url https://bitbucket.org/mpapis/rvm/raw/master/binscripts/rvm-installer    ; }
  if ($host = get-git.rvm.io ) { rewrite ^ https://rvm.io/install/git permanent; break; }
  if ($host = get.rvm.io ) { rewrite ^ $get_url permanent ; break; }

  location ~ /(binaries|vboxes) {
    lingering_time 120;
    autoindex on;
    autoindex_exact_size off;
    try_files $uri $uri/ =404;
  }

  location / {
    rewrite ^/(.*)/index\.html$ /$1 permanent;
    rewrite ^/index\.html$ / permanent;
    rewrite ^/(.*)/$ /$1 permanent;
    try_files $uri $uri/index.html =404;
  }

  error_page 403 404 500 502 503 504 /error;
}
