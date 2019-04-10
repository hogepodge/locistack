#!/bin/bash
set -x

/scripts/cinder/generate-configs.sh
/scripts/cinder/initialize-cinder-database.sh
/scripts/cinder/initialize-keystone.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --http :8776 \
      --wsgi-file /var/lib/openstack/bin/cinder-wsgi
