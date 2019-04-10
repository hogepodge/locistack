#!/bin/bash
set -x

/scripts/common/wait-for-service.sh Keystone 5000

/scripts/cinder/generate-configs.sh
/scripts/cinder/initialize-cinder-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --http :8776 \
      --wsgi-file /var/lib/openstack/bin/cinder-wsgi
