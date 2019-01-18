#!/bin/bash
set -x

/scripts/nova/generate-configs.sh

mkdir -p /var/lib/nova/instances
chown -R nova:root /var/lib/nova

# need to put nova-rootwrap in the path
ln -s /var/lib/openstack/bin/nova-rootwrap /usr/bin/nova-rootwrap

until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:8774); do
    printf 'wait on Nova API'
    sleep 5
done

# Launch the compute process, give it time to start up, then register with Nova cells
nova-compute &
COMPUTE_PROCESS=$!
sleep 30

source /scripts/common/adminrc
nova-manage cell_v2 discover_hosts --verbose

wait $COMPUTE_PROCESS
