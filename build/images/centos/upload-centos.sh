source /home/hoge/locistack/deploy/adminrc

OPENSTACK='openstack'

ARCH=$(uname -m)
IMAGE=centos.qcow2
IMAGE_NAME=centos
IMAGE_TYPE=linux

# Test for credentials set
if [[ "${OS_USERNAME}" == "" ]]; then
    echo "No Keystone credentials specified.  Try running source /scripts/common/adminrc"
    exit
fi


echo "Test for the image ${IMAGE_NAME}"
${OPENSTACK} image list | grep -q ${IMAGE_NAME}
if [ $? -eq 1 ]; then
    echo "The image ${IMAGE_NAME} does not exist. Creating."

    EXTRA_PROPERTIES=
    if [ ${ARCH} == aarch64 ]; then
        EXTRA_PROPERTIES="--property hw_firmware_type=uefi"
    fi

    echo "Uploading ${IMAGE_NAME} image to Glance"
    ${OPENSTACK} image create --disk-format qcow2 \
                              --container-format bare \
                              --public \
                              --property os_type=${IMAGE_TYPE} \
                              ${EXTRA_PROPERTIES} \
                              --file ./${IMAGE} \
                              ${IMAGE_NAME}
fi

