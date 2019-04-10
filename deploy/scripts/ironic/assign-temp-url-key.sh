#!/bin/bash

source /scripts/ironic/glancerc

until $(curl --output /dev/null --silent --head http://${CONTROL_HOST_IP}:8888); do
    printf 'Wait on Swift proxy.'
    sleep 5
done

openstack object store account set --property Temp-Url-Key=${IRONIC_TEMP_URL_KEY}
