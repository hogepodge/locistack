#!/bin/bash
#
# This script is meant to be run once after running start for the first
# time.  This script downloads a cirros image and registers it.  Then it
# configures networking and nova quotas to allow 40 m1.small instances
# to be created.
set -x

source /scripts/common/adminrc

# Wait for all services to start

function wait_for_it() {
  local HOST=$1
  local PORT=$2
  local PROTOCOL=$3
  local SERVICE=$4

  until $(curl --output /dev/null \
               --silent \
	       ${PROTOCOL}://${HOST}:${PORT}); do
    printf "Waiting on ${SERVICE}."
    sleep 5
  done
  printf "${SERVICE} available."
}


wait_for_it ${CONTROL_HOST_IP} 5000 '--fail http' 'Keystone'
wait_for_it ${CONTROL_HOST_IP} 9292 '--fail http' 'Glance'
wait_for_it ${CONTROL_HOST_IP} 9696 'http'  'Neutron'
wait_for_it ${CONTROL_HOST_IP} 8774 '--fail http' 'Nova'
wait_for_it ${CONTROL_HOST_IP} 6385 '--fail http' 'Ironic'

OPENSTACK=openstack

# Sanitize language settings to avoid commands bailing out
# with "unsupported locale setting" errors.
unset LANG
unset LANGUAGE
LC_ALL=C
export LC_ALL
for i in curl "${OPENSTACK}"; do
    if [[ ! $(type ${i} 2>/dev/null) ]]; then
        if [ "${i}" == 'curl' ]; then
            echo "Please install ${i} before proceeding"
        else
            echo "Please install python-openstackclient before proceeding"
        fi  
        exit
    fi  
done

# Test for credentials set
if [[ "${OS_USERNAME}" == "" ]]; then
    echo "No Keystone credentials specified.  Try running source /scripts/common/adminrc"
    exit
fi

# Get admin user and tenant IDs
echo "Getting the user/tenant tuple for the admin user"
ADMIN_USER_ID=$(${OPENSTACK} user list | awk '/ admin / {print $2}')
ADMIN_PROJECT_ID=$(${OPENSTACK} project list | awk '/ admin / {print $2}')

echo "Getting the default security group."
ADMIN_SEC_GROUP=$(${OPENSTACK} security group list --project ${ADMIN_PROJECT_ID} | awk '/ default / {print $2}')

# Sec Group Config
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
    --protocol icmp ${ADMIN_SEC_GROUP}
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
   --protocol tcp --dst-port 22 ${ADMIN_SEC_GROUP}

${OPENSTACK} quota set --instances 40 ${ADMIN_PROJECT_ID}

# 40 cores
${OPENSTACK} quota set --cores 40 ${ADMIN_PROJECT_ID}

# 96GB ram
${OPENSTACK} quota set --ram 96000 ${ADMIN_PROJECT_ID}

/scripts/post-install/enroll.sh

cat << EOF
locistack bare metal is installed and configured.
EOF
