#!/bin/bash

SERVICE_NAME=neutron
SERVICE_TYPE=network
SERVICE_DESCRIPTION="OpenStack Networking Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:9696
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:9696
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:9696


/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"
