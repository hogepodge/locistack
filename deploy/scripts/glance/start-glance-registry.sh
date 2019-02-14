#!/bin/bash
set -x

cp /scripts/glance/glance-api-paste.ini /etc/glance/glance-api-paste.ini
cp /scripts/glance/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini

# Wait for Glance API to start
until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:9292); do
    printf 'wait on Glance API'
    sleep 5
done

/scripts/glance/initialize-glance.sh
glance-registry
