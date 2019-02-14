#!/bin/bash
set -x

sudo losetup /dev/loop0 cinder-storage
sudo sfdisk /dev/loop0 << EOF
,,8e,,
EOF

yes | sudo pvcreate /dev/loop0
sudo vgcreate cinder-volumes /dev/loop0
