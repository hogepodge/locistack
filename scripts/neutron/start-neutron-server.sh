#!/bin/bash

set -x

/scripts/neutron/generate-configs.sh
/scripts/neutron/initialize-keystone.sh
/scripts/neutron/initialize-neutron-database.sh

# I would love to run this as uwsgi, but it needs more investigation
# because the neutron team just _has_ to be different from every
# other OpenStack service. What's the difference between neutron-server
# and neutron-api (which is the uwsgi frontend)? Who knows?
neutron-server \
    --config-file /etc/neutron/neutron.conf \
    --config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
    --config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
    --config-file /etc/neutron/dhcp_agent.ini \
    --config-file /etc/neutron/l3_agent.ini
