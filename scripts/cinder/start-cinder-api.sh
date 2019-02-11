#!/bin/bash
set -x

/scripts/cinder/initialize-keystone.sh
/scripts/cinder/generate-configs.sh
/scripts/cinder/initialize-cinder-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --https :8776,/tls/openstack.crt,/tls/openstack.key \
      --wsgi-file /var/lib/openstack/bin/cinder-api-wsgi
