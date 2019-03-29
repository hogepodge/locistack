#!/bin/bash

# Wait for ironic
until $(curl --output /dev/null --silent --head https://${CONTROL_HOST_IP}:6385); do
    printf '.'
    sleep 5
done

/scripts/ironic/generate-configs.sh
ironic-conductor
