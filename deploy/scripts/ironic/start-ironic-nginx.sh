#!/bin/bash
set -x

mkdir -p /etc/nginx
cp /scripts/ironic/nginx.conf /etc/nginx/nginx.conf

/usr/sbin/nginx -c /etc/nginx/nginx.conf -g 'daemon off;'
