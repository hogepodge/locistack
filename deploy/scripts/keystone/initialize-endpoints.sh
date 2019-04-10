#!/bin/bash

# load all of the endpoints serially, since if we do it
# in parallel our little keystone service gets overwhelmed

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

SERVICE_NAME=glance
SERVICE_TYPE=image
SERVICE_DESCRIPTION="OpenStack Image Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:9292
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:9292
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:9292

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

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

SERVICE_NAME=placement
SERVICE_TYPE=placement
SERVICE_DESCRIPTION="OpenStack Placement Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=http://${CONTROL_HOST_IP}:8778
PRIVATE_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8778
ADMIN_ENDPOINT=http://${CONTROL_HOST_PRIVATE_IP}:8778

/scripts/common/initialize-keystone.sh "${SERVICE_NAME}" \
                                       "${SERVICE_TYPE}" \
                                       "${SERVICE_DESCRIPTION}" \
                                       "${SERVICE_PASSWORD}" \
                                       "${PUBLIC_ENDPOINT}" \
                                       "${PRIVATE_ENDPOINT}" \
                                       "${ADMIN_ENDPOINT}"

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
