#!/usr/bin/env bash

REFERENCE_FILE="/etc/letsencrypt/live/rvm.io/last-update"
FULLCHAIN_FILE="/etc/letsencrypt/live/rvm.io/fullchain.pem"

if
  [[ ${FULLCHAIN_FILE} -nt ${REFERENCE_FILE} ]]
then
  service nginx reload
  touch ${REFERENCE_FILE}
fi
