#!/bin/sh
set -x

# Create a bunch of shared directories
mkdir -p /imagedata/httpboot
mkdir -p /imagedata/tftpboot
mkdir -p /imagedata/tmp
mkdir -p /data
mkdir -p /data/tmp
mkdir -p /data/cache
mkdir -p /imagedata/httpboot
mkdir -p /imagedata/httpboot/pxelinux.cfg
mkdir -p /imagedata/httpboot/master_images
mkdir -p /imagedata/tftpboot
mkdir -p /imagedata/tftpboot/pxelinux.cfg
mkdir -p /imagedata/tftpboot/master_images

# Copy over the httpboot and tftpboot configrations
cp -r  /scripts/ironic/httpboot/* /imagedata/httpboot/.
cp -r  /scripts/ironic/tftpboot/* /imagedata/tftpboot/.
cp -r /var/lib/tftpboot/* /imagedata/tftpboot/.
cp /usr/share/ipxe/{undionly.kpxe,ipxe.efi} /imagedata/tftpboot
chown -R ironic:root /imagedata
