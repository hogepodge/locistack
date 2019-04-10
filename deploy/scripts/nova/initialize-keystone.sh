#!/bin/bash
set -x

SERVICE_NAME=nova
SERVICE_TYPE=compute
SERVICE_DESCRIPTION="OpenStack Compute Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:8774/v2.1
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8774/v2.1
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8774/v2.1

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

