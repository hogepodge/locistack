#!/bin/bash
set -x

OPENSTACK="openstack --insecure"

until $(curl --output /dev/null --silent --head --fail --insecure https://${CONTROL_HOST_IP}:5000); do
    printf '.'
    sleep 5
done

SERVICE_NAME=glance
SERVICE_TYPE=image
SERVICE_DESCRIPTION="OpenStack Image Service"
SERVICE_PASSWORD=${SERVICE_PASSWORD}
PUBLIC_ENDPOINT=https://${CONTROL_HOST_IP}:9292
PRIVATE_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:9292
ADMIN_ENDPOINT=https://${CONTROL_HOST_PRIVATE_IP}:9292

function create_service_user() {
    local SERVICE_NAME="$1"
    local SERVICE_PASSWORD="$2"
    local OPENSTACK="$3"

    ${OPENSTACK} user show ${SERVICE_NAME}

    if [ $? -eq 1 ]
    then
        ${OPENSTACK} user create --password ${SERVICE_PASSWORD} ${SERVICE_NAME}
        ${OPENSTACK} role add --user ${SERVICE_NAME} --project service admin
    fi
}

function create_service() {
  local SERVICE_NAME="$1"
  local SERVICE_TYPE="$2"
  local SERVICE_DESCRIPTION="$3"
  local OPENSTACK="$4"

  ${OPENSTACK} service show ${SERVICE_NAME}

  if [ $? -eq 1 ]
  then
      ${OPENSTACK} service create --name ${SERVICE_NAME} \
                                          --description "${SERVICE_DESCRIPTION}" \
                                          ${SERVICE_TYPE}
  fi
}

function create_service_endpoint() {
  local SERVICE_TYPE="$1"
  local ENDPOINT_TYPE="$2"
  local ENDPOINT="$3"
  local REGION="$4"
  local OPENSTACK="$5"

  ${OPENSTACK} endpoint list | \
      grep ${REGION} | \
      grep ${SERVICE_TYPE} | \
      grep ${ENDPOINT_TYPE} | \
      grep ${ENDPOINT}

  if [ $? -eq 1 ]
  then
      ${OPENSTACK} endpoint create --region ${REGION} \
                                          ${SERVICE_TYPE} \
                                          ${ENDPOINT_TYPE} \
                                          ${ENDPOINT}
  fi
}

function initialize_service() {
    local SERVICE_NAME="$1"
    local SERVICE_TYPE="$2"
    local SERVICE_DESCRIPTION="$3"
    local SERVICE_PASSWORD="$4"
    local PUBLIC_ENDPOINT="$5"
    local INTERNAL_ENDPOINT="$6"
    local ADMIN_ENDPOINT="$7"
    local REGION="$8"
    local OPENSTACK="$9"

    ${OPENSTACK} project show service

    if [ $? -eq 1 ]
    then
        ${OPENSTACK} project create service --description "General service project"
    fi

    create_service_user ${SERVICE_NAME} ${SERVICE_PASSWORD} "${OPENSTACK}"
    create_service ${SERVICE_NAME} ${SERVICE_TYPE} "${SERVICE_DESCRIPTION}" "${OPENSTACK}"
    create_service_endpoint ${SERVICE_TYPE} public ${PUBLIC_ENDPOINT} ${REGION} "${OPENSTACK}"
    create_service_endpoint ${SERVICE_TYPE} internal ${INTERNAL_ENDPOINT} ${REGION} "${OPENSTACK}"
    create_service_endpoint ${SERVICE_TYPE} admin ${ADMIN_ENDPOINT} ${REGION} "${OPENSTACK}"
}

export OS_USERNAME=admin
export OS_PASSWORD=${KEYSTONE_ADMIN_PASSWORD}
export OS_TENANT_NAME=admin
export OS_AUTH_URL=https://${CONTROL_HOST_IP}:5000/v3
export OS_REGION_NAME=RegionOne
export OS_IDENTITY_API_VERSION=3


initialize_service \
    $SERVICE_NAME \
    $SERVICE_TYPE \
    "$SERVICE_DESCRIPTION" \
    $SERVICE_PASSWORD \
    $PUBLIC_ENDPOINT \
    $PRIVATE_ENDPOINT \
    $ADMIN_ENDPOINT \
    RegionOne \
    "$OPENSTACK"
