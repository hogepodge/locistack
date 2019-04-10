#!/bin/bash
source /scripts/common/adminrc
set -x

OPENSTACK=openstack

# Keystone may not be done setting up, so wait for the endpoints.
ENDPOINT=$(openstack endpoint list | grep network | grep public)
echo $ENDPOINT
while [ -z "$ENDPOINT" ]; do
   ENDPOINT=$(openstack endpoint list | grep network | grep public)
done

ENDPOINT=$(openstack endpoint list | grep network | grep internal)
while [ -z "$ENDPOINT" ]; do
   ENDPOINT=$(openstack endpoint list | grep network | grep internal)
done

ENDPOINT=$(openstack endpoint list | grep network | grep admin)
while [ -z "$ENDPOINT" ]; do
   ENDPOINT=$(openstack endpoint list | grep network | grep admin)
done

# Both of these commands are safe to run multiple times (idempotent)
# In the instance where the resources don't exist, they will be
# created. In the instance where they do exist, this will error
# with a no-op.

${OPENSTACK} network create --share \
                            --external \
                            --provider-physical-network provider \
                            --provider-network-type flat \
                            provider

# It's assumed that this provider network has an existing dhcp server
${OPENSTACK} subnet create --subnet-range ${PROVIDER_SUBNET} \
                           --gateway ${PROVIDER_GATEWAY} \
                           --network provider \
                           --allocation-pool start=${PROVIDER_POOL_START},end=${PROVIDER_POOL_END} \
                           --dns-nameserver ${PROVIDER_DNS_NAMESERVER} \
                           --no-dhcp \
                           provider
