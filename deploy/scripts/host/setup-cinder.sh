#!/bin/bash
set -x

sudo truncate --size=20G cinder-storage
sudo losetup /dev/loop1 cinder-storage
sudo sfdisk /dev/loop1 << EOF
,,8e,,
EOF

sudo pvcreate /dev/loop1
sudo vgcreate cinder-volumes /dev/loop1
