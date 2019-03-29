#!/bin/bash
set -x

# Copy over base configurations, like policies and rootwrap
mkdir -p /etc/ironic

# generate the rest of the configurations
/scripts/ironic/generate.ironic.conf.sh

cp /scripts/ironic/boot.ipxe /etc/ironic/boot.ipxe

# setup sudoers for nova commands
chown -R root:ironic /etc/ironic
