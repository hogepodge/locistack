#!/bin/bash
set -x

/scripts/nova/generate-configs.sh

until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:8774); do
    printf 'wait on Nova API'
    sleep 5
done

uwsgi --uid 42424 \
      --gid 42424 \
      --https :8775,/tls/openstack.crt,/tls/openstack.key \
      --wsgi-file /var/lib/openstack/bin/nova-metadata-wsgi
