#!/bin/bash
set -x

/scripts/cinder/generate-configs.sh

YUM = $(which yum)
APT = $(which apt-get)

# There's a few things that aren't in the older LOCI images,
# we'll add them here just to be safe
yum install -y epel-release
yum update -y
yum install -y scsi-target-utils

sed -i -e 's/udev_sync = 1/udev_sync = 0/g' /etc/lvm/lvm.conf
sed -i -e 's/udev_rules = 1/udev_rules = 0/g' /etc/lvm/lvm.conf
sed -i -e 's/use_lvmetad = 0/use_lvmetad =1/g' /etc/lvm/lvm.conf
echo "include /var/lib/cinder/volumes/*" >> /etc/tgt/targets.conf

until $(curl --output /dev/null --silent --head --insecure https://${CONTROL_HOST_IP}:8776); do
    printf 'wait on Cinder API'
    sleep 5
done


/usr/sbin/tgtd
/var/lib/openstack/bin/cinder-volume
