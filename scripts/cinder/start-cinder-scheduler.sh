#!/bin/bash
set -x

/scripts/cinder/generate-configs.sh

until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:8776); do
    printf 'wait on Cinder API'
    sleep 5
done

/var/lib/openstack/bin/cinder-scheduler
