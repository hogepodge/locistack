#!/bin/bash
set -x

/scripts/nova/generate-configs.sh

mkdir -p /var/lib/nova/instances
chown -R nova:root /var/lib/nova

# need to put nova-rootwrap in the path
ln -s /var/lib/openstack/bin/nova-rootwrap /usr/bin/nova-rootwrap

/scripts/common/wait-for-service.sh Nova 8774

# Launch the compute process, give it time to start up, then register with Nova cells
nova-compute &
COMPUTE_PROCESS=$!
sleep 30

source /scripts/common/adminrc
nova-manage cell_v2 discover_hosts --verbose

wait $COMPUTE_PROCESS
