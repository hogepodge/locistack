DIB_DEV_USER_USERNAME=hoge \
DIB_DEV_USER_PWDLESS_SUDO=true \
DIB_DEV_USER_AUTHORIZED_KEYS=~/.ssh/id_rsa.pub \
ELEMENTS_PATH=$HOME/locistack/build/images/elements \
disk-image-create \
    centos7 \
    cloud-init-nocloud \
    devuser \
    dhcp-all-interfaces \
    epel \
    grub2 \
    kubernetes \
    vm \
    yum \
    -o k8s.qcow2 \
    -p vim

