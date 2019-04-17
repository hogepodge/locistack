#!/bin/bash
set -x

SERVICE_NAME=cinder
SERVICE_TYPE=volume
SERVICE_DESCRIPTION="OpenStack Volume Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:8776/v3/%\(project_id\)s
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8776/v3/%\(project_id\)s
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8776/v3/%\(project_id\)s

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

SERVICE_NAME=cinderv2
SERVICE_TYPE=volumev2
SERVICE_DESCRIPTION="OpenStack Volume Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:8776/v2/%\(project_id\)s
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8776/v2/%\(project_id\)s
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8776/v2/%\(project_id\)s

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

