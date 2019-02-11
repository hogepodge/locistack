#!/bin/bash
set -x

SERVICE_NAME=cinder
SERVICE_TYPE=volume
SERVICE_DESCRIPTION="OpenStack Volume Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=https://${CONTROL_HOST_IP}:8776/v3/%\(project_id\)s
PRIVATE_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8776/v3/%\(project_id\)s
ADMIN_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:8776/v3/%\(project_id\)s

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"
