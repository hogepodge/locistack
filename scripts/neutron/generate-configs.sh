#!/bin/bash
set -x
cp -R /var/lib/openstack/etc/neutron /etc/neutron
/generate.linuxbridge_agent.ini.sh
/generate.neutron.conf.sh
/generate.metadata_agent.ini.sh
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
