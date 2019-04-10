#!/bin/bash
set -x

# Copy over base configurations, like policies and rootwrap
mkdir -p /etc/cinder
cp -R /scripts/cinder/etc/cinder/* /etc/cinder/.

# generate the rest of the configurations
/scripts/cinder/generate.cinder.conf.sh

# setup sudoers for cinder commands
cp /scripts/cinder/cinder_sudoers /etc/sudoers.d/cinder_sudoers
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/cinder_sudoers
chown -R root:cinder /etc/cinder
chmod 740 /etc/cinder/rootwrap.conf
chmod -R 740 /etc/cinder/rootwrap.d
