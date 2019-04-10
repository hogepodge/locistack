#!/bin/bash
set -x

/scripts/nova/initialize-keystone.sh
/scripts/common/wait-for-service.sh Cinder 8776
/scripts/common/wait-for-service.sh Glance 9292
/scripts/common/wait-for-service.sh Placement 8778

/scripts/nova/generate-configs.sh
/scripts/nova/initialize-nova-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --http :8774 \
      --wsgi-file /var/lib/openstack/bin/nova-api-wsgi

