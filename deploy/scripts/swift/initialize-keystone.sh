#!/bin/bash
set -x

SERVICE_NAME=swift
SERVICE_TYPE=object-store
SERVICE_DESCRIPTION="OpenStack Object Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:8888/v1/AUTH_%\(tenant_id\)s
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8888/v1/AUTH_%\(tenant_id\)s
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8888

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

