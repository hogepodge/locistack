#!/bin/bash
set -x

/scripts/nova/initialize-keystone.sh
/scripts/nova/generate-configs.sh
/scripts/nova/initialize-nova-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --https :8775,/tls/openstack.crt,/tls/openstack.key \
      --wsgi-file /var/lib/openstack/bin/nova-metadata-wsgi
