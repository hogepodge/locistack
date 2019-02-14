#!/bin/bash
set -x

# Copy over base configurations, like policies and rootwrap
mkdir -p /etc/nova
cp -R /scripts/nova/etc/nova/* /etc/nova/.

# generate the rest of the configurations
/scripts/nova/generate.nova.conf.sh

# setup sudoers for nova commands
cp /scripts/nova/nova_sudoers /etc/sudoers.d/nova_sudoers
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/nova_sudoers
chown -R root:nova /etc/nova
chmod 740 /etc/nova/rootwrap.conf
chmod -R 740 /etc/nova/rootwrap.d

