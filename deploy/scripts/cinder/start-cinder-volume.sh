#!/bin/bash
set -x

/scripts/cinder/generate-configs.sh

sed -i -e 's/udev_sync = 1/udev_sync = 0/g' /etc/lvm/lvm.conf
sed -i -e 's/udev_rules = 1/udev_rules = 0/g' /etc/lvm/lvm.conf
sed -i -e 's/use_lvmetad = 0/use_lvmetad =1/g' /etc/lvm/lvm.conf
echo "include /var/lib/cinder/volumes/*" >> /etc/tgt/targets.conf

/scripts/common/wait-for-service.sh Cinder 8776

/usr/sbin/tgtd
/var/lib/openstack/bin/cinder-volume
