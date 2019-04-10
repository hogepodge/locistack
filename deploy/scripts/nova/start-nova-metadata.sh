#!/bin/bash
set -x

/scripts/nova/generate-configs.sh

/scripts/common/wait-for-service.sh Nova 8774

uwsgi --uid 42424 \
      --gid 42424 \
      --http :8775 \
      --wsgi-file /var/lib/openstack/bin/nova-metadata-wsgi
