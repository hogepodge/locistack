#!/bin/bash
# Get the tinyipa images and upload to Glance

set -x

function wait_for_it() {
  local HOST=$1
  local PORT=$2
  local PROTOCOL=$3
  local SERVICE=$4

  until $(curl --output /dev/null \
               --silent \
	       --head \
	       ${PROTOCOL}://${HOST}:${PORT}); do
    printf "Waiting on ${SERVICE}."
    sleep 5
  done
  printf "${SERVICE} available."
}

wait_for_it ${CONTROL_HOST_IP} 5000 'http' 'Keystone'
wait_for_it ${CONTROL_HOST_IP} 8888 'http' 'Swift'
wait_for_it ${CONTROL_HOST_IP} 9292 'http' 'Glance'

OPENSTACK=openstack

source /scripts/common/adminrc

#curl -o tinyapi-stable-rocky.tar.gz \
#  http://tarballs.openstack.org/ironic-python-agent/tinyipa/tinyipa-stable-rocky.tar.gz

#tar -xvzf tinyapi-stable-rocky.tar.gz

${OPENSTACK} image list | grep -q tinyipa.vmlinuz
if [ $? -eq 1 ]; then
    ${OPENSTACK} image create \
      --shared \
      --id 11111111-1111-1111-1111-111111111110 \
      --disk-format aki \
      --container-format aki \
      --file /scripts/ironic/tinyipa-stable-rocky.vmlinuz \
      tinyipa.vmlinuz
fi

${OPENSTACK} image list | grep -q tinyipa.ramdisk
if [ $? -eq 1 ]; then
    ${OPENSTACK} image create \
      --shared \
      --id 11111111-1111-1111-1111-111111111111 \
      --disk-format ari \
      --container-format ari \
      --file /scripts/ironic/tinyipa-stable-rocky.gz \
      tinyipa.ramdisk
fi
