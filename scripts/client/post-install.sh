#!/bin/bash
#
# This script is meant to be run once after running start for the first
# time.  This script downloads a cirros image and registers it.  Then it
# configures networking and nova quotas to allow 40 m1.small instances
# to be created.
set -x

OPENSTACK="openstack --insecure"

ARCH=$(uname -m)
IMAGE_URL=http://download.cirros-cloud.net/0.4.0/
IMAGE=cirros-0.4.0-${ARCH}-disk.img
IMAGE_NAME=cirros
IMAGE_TYPE=linux


# Sanitize language settings to avoid commands bailing out
# with "unsupported locale setting" errors.
unset LANG
unset LANGUAGE
LC_ALL=C
export LC_ALL
for i in curl "${OPENSTACK}"; do
    if [[ ! $(type ${i} 2>/dev/null) ]]; then
        if [ "${i}" == 'curl' ]; then
            echo "Please install ${i} before proceeding"
        else
            echo "Please install python-${i}client before proceeding"
        fi  
        exit
    fi  
done

# Test for credentials set
if [[ "${OS_USERNAME}" == "" ]]; then
    echo "No Keystone credentials specified.  Try running source /scripts/common/adminrc"
    exit
fi

# Test to ensure configure script is run only once
if ${OPENSTACK} image list | grep -q cirros; then
    echo "This tool should only be run once per deployment."
    exit
fi

echo Downloading glance image.
if ! [ -f "${IMAGE}" ]; then
    curl -L -o ./${IMAGE} ${IMAGE_URL}/${IMAGE}
fi

EXTRA_PROPERTIES=
if [ ${ARCH} == aarch64 ]; then
    EXTRA_PROPERTIES="--property hw_firmware_type=uefi"
fi

echo Creating glance image.
${OPENSTACK} image create --disk-format qcow2 --container-format bare --public \
    --property os_type=${IMAGE_TYPE} ${EXTRA_PROPERTIES} --file ./${IMAGE} ${IMAGE_NAME}

${OPENSTACK} network create --provider-network-type vxlan demo-net
${OPENSTACK} subnet create --subnet-range 10.0.0.0/24 --network demo-net \
    --gateway 10.0.0.1 --dns-nameserver 8.8.8.8 demo-subnet

${OPENSTACK} router create demo-router
${OPENSTACK} router add subnet demo-router demo-subnet
${OPENSTACK} router set --external-gateway public1 demo-router

# Get admin user and tenant IDs
ADMIN_USER_ID=$(${OPENSTACK} user list | awk '/ admin / {print $2}')
ADMIN_PROJECT_ID=$(${OPENSTACK} project list | awk '/ admin / {print $2}')
ADMIN_SEC_GROUP=$(${OPENSTACK} security group list --project ${ADMIN_PROJECT_ID} | awk '/ default / {print $2}')

i# Sec Group Config
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
    --protocol icmp ${ADMIN_SEC_GROUP}
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
    --protocol tcp --dst-port 22 ${ADMIN_SEC_GROUP}
# Open heat-cfn so it can run on a different host
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
    --protocol tcp --dst-port 8000 ${ADMIN_SEC_GROUP}
${OPENSTACK} security group rule create --ingress --ethertype IPv4 \
    --protocol tcp --dst-port 8080 ${ADMIN_SEC_GROUP}

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo Generating ssh key.
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
fi
if [ -r ~/.ssh/id_rsa.pub ]; then
    echo Configuring nova public key and quotas.
    ${OPENSTACK} keypair create --public-key ~/.ssh/id_rsa.pub mykey
fi

# Increase the quota to allow 40 m1.small instances to be created

# 40 instances
${OPENSTACK} quota set --instances 40 ${ADMIN_PROJECT_ID}

# 40 cores
${OPENSTACK} quota set --cores 40 ${ADMIN_PROJECT_ID}

# 96GB ram
${OPENSTACK} quota set --ram 96000 ${ADMIN_PROJECT_ID}

# add default flavors, if they don't already exist
if ! ${OPENSTACK} flavor list | grep -q m1.tiny; then
    ${OPENSTACK} flavor create --id 1 --ram 512 --disk 1 --vcpus 1 m1.tiny
    ${OPENSTACK} flavor create --id 2 --ram 2048 --disk 20 --vcpus 1 m1.small
    ${OPENSTACK} flavor create --id 3 --ram 4096 --disk 40 --vcpus 2 m1.medium
    ${OPENSTACK} flavor create --id 4 --ram 8192 --disk 80 --vcpus 4 m1.large
    ${OPENSTACK} flavor create --id 5 --ram 16384 --disk 160 --vcpus 6 m1.xlarge
fi

DEMO_NET_ID=$(openstack network list | awk '/ demo-net / {print $2}')

cat << EOF
Done.
To deploy a demo instance, run:
openstack server create \\
    --image ${IMAGE_NAME} \\
    --flavor m1.tiny \\
    --key-name mykey \\
    --nic net-id=${DEMO_NET_ID} \\
    demo1
EOF

