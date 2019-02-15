#!/bin/bash
set -x

sudo losetup /dev/loop0 cinder-storage
sudo sfdisk /dev/loop0 << EOF
,,8e,,
EOF

sudo losetup -d /dev/loop0
