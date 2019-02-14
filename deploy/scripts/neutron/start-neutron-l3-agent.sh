#!/bin/bash
set -x

/scripts/neutron/generate-configs.sh

until $(curl --output /dev/null --silent --head http://${CONTROL_HOST_IP}:9696); do
    printf 'wait on Neutron API'
    sleep 5
done

neutron-l3-agent \
    --config-file /etc/neutron/neutron.conf \
    --config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
    --config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
    --config-file /etc/neutron/dhcp_agent.ini \
    --config-file /etc/neutron/l3_agent.ini \
    --config-file /etc/neutron/metadata_agent.ini
