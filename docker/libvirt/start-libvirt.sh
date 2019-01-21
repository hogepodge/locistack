#!/usr/bin/bash
set -x

mkdir -p /var/log/locistack
touch /var/log/locistack/qemu.log
touch /var/log/locistack/libvirt.log

#echo "cgroup_controllers = [ ]" >> /etc/libvirt/qemu.conf

/usr/sbin/virtlogd &
/usr/sbin/libvirtd -l
