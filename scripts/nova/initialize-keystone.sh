#!/bin/bash
set -x

SERVICE_NAME=nova
SERVICE_TYPE=compute
SERVICE_DESCRIPTION="OpenStack Compute Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=https://${CONTROL_HOST_IP}:8774/v2.1
PRIVATE_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8774/v2.1
ADMIN_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8774/v2.1

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

SERVICE_NAME=placement
SERVICE_TYPE=placement
SERVICE_DESCRIPTION="OpenStack Placement Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=https://${CONTROL_HOST_IP}:8778
PRIVATE_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8778
ADMIN_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8778

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"
