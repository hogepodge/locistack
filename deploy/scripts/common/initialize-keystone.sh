#!/bin/bash
set -x

SERVICE_NAME="$1"
SERVICE_TYPE="$2"
SERVICE_DESCRIPTION="$3"
SERVICE_PASSWORD="$4"
PUBLIC_ENDPOINT="$5"
PRIVATE_ENDPOINT="$6"
ADMIN_ENDPOINT="$7"

OPENSTACK=openstack

/scripts/common/wait-for-service.sh Keystone 5000

function ensure_user() {
    local USER_NAME="$1"
    local USER_PASSWORD="$2"
    local OPENSTACK="$3"


    local EXISTS=$(${OPENSTACK} user list | grep "${USER_NAME} ")
    while [ -z "$EXISTS" ]; do
        ${OPENSTACK} user create --password ${USER_PASSWORD} ${USER_NAME}
        EXISTS=$(${OPENSTACK} user list | grep "${USER_NAME} ")
    done
}

function ensure_role() {
    local USER_NAME="$1"
    local USER_PROJECT="$2"
    local USER_ROLE="$3"
    local OPENSTACK="$4"

    local EXISTS=$(${OPENSTACK} role assignment list --name |
        grep ${USER_NAME} |
        grep ${USER_PROJECT} |
        grep ${USER_ROLE})
    while [ -z "$EXISTS" ]; do
        ${OPENSTACK} role add --user ${USER_NAME} \
                              --project ${USER_PROJECT} \
                              ${USER_ROLE}
        EXISTS=$(${OPENSTACK} role assignment list --name |
            grep ${USER_NAME} |
            grep ${USER_PROJECT} |
            grep ${USER_ROLE})
    done
}

function ensure_service() {
  local SERVICE_NAME="$1"
  local SERVICE_TYPE="$2"
  local SERVICE_DESCRIPTION="$3"
  local OPENSTACK="$4"

  local EXISTS=$(${OPENSTACK} service list | grep "${SERVICE_NAME} ")
  while [ -z "$EXISTS" ]; do
      ${OPENSTACK} service create --name ${SERVICE_NAME} \
                                  --description "${SERVICE_DESCRIPTION}" \
                                  ${SERVICE_TYPE}
      sleep 1
      EXISTS=$(${OPENSTACK} service list | grep "${SERVICE_NAME} ")
  done
}

function ensure_service_endpoint() {
  local SERVICE_TYPE="$1"
  local ENDPOINT_TYPE="$2"
  local ENDPOINT="$3"
  local REGION="$4"
  local OPENSTACK="$5"

  local EXISTS=$(${OPENSTACK} endpoint list |
      grep "${REGION}" |
      grep "${SERVICE_TYPE} " |
      grep "${ENDPOINT_TYPE}" |
      grep "${ENDPOINT}")

  while [ -z "$EXISTS" ]; do
     ${OPENSTACK} endpoint create --region "${REGION}" \
                                          "${SERVICE_TYPE}" \
                                          "${ENDPOINT_TYPE}" \
                                          "${ENDPOINT}"
     sleep 1
     EXISTS=$(${OPENSTACK} endpoint list |
        grep "${REGION}" |
        grep "${SERVICE_TYPE} " |
        grep "${ENDPOINT_TYPE}" |
        grep "${ENDPOINT}")
  done
}

function ensure_project() {
    local PROJECT_NAME="$1"
    local PROJECT_DESCRIPTION="$2"
    local OPENSTACK="$3"

    local EXISTS=$(${OPENSTACK} project list | grep ${PROJECT_NAME})
    while [ -z "$EXISTS" ]; do
        ${OPENSTACK} project create ${PROJECT_NAME} \
                                    --description "${PROJECT_DESCRIPTION}"
        sleep 1
        EXISTS=$(${OPENSTACK} project list | grep ${PROJECT_NAME})
    done
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

    ensure_project service "General service project" "${OPENSTACK}"
    ensure_user ${SERVICE_NAME} ${SERVICE_PASSWORD} "${OPENSTACK}"
    ensure_role ${SERVICE_NAME} service admin "${OPENSTACK}"
    ensure_service ${SERVICE_NAME} ${SERVICE_TYPE} "${SERVICE_DESCRIPTION}" "${OPENSTACK}"
    ensure_service_endpoint ${SERVICE_TYPE} public ${PUBLIC_ENDPOINT} ${REGION} "${OPENSTACK}"
    ensure_service_endpoint ${SERVICE_TYPE} internal ${INTERNAL_ENDPOINT} ${REGION} "${OPENSTACK}"
    ensure_service_endpoint ${SERVICE_TYPE} admin ${ADMIN_ENDPOINT} ${REGION} "${OPENSTACK}"
}

export OS_USERNAME=admin
export OS_PASSWORD=${KEYSTONE_ADMIN_PASSWORD}
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://${CONTROL_HOST_IP}:5000/v3
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
    "${OPENSTACK}"
