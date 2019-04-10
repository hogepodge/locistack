#!/bin/bash
set -x

SERVICE_NAME=ironic
SERVICE_TYPE=baremetal
SERVICE_DESCRIPTION="OpenStack Bare Metal Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:6385
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:6385
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:6385

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

