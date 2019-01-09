#!/bin/bash
set -x


# Make the ml2 plugin directory, copy the config over, and link to it
mkdir -p /etc/neutron/plugins/ml2
cp /scripts/neutron/plugins/ml2/ml2_conf.ini /ets/neutron/plugins/ml2/ml2_conf.ini
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

# Copy over all the rootwrap and policy configuration
cp -R /var/lib/openstack/etc/neutron /etc/neutron

# generate the rest of the configurations
/scripts/neutron/plugins/ml2/generate.linuxbridge_agent.ini.sh
/scripts/neutron/generate.neutron.conf.sh
/scripts/neutron/generate.metadata_agent.ini.sh

# setup sudoers for neutron commands
cp /scripts/neutron/neutron_sudoers /etc/sudoers.d/neutron_sudoers
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/neutron_sudoers
chown -R root:neutron /etc/neutron

