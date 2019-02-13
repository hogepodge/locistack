#!/bin/bash
set -x

/scripts/nova/generate-configs.sh

until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:8774); do
    printf 'wait on Nova API'
    sleep 5
done

/var/lib/openstack/bin/nova-novncproxy
