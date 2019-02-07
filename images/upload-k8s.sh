source /scripts/common/adminrc

OPENSTACK='openstack --insecure'

function wait_for_it() {
  local HOST=$1
  local PORT=$2
  local PROTOCOL=$3
  local SERVICE=$4

  until $(curl --output /dev/null \
               --silent \
	       --head \
	       ${PROTOCOL}://${HOST}:${PORT}); do
    printf "Waiting on ${SERVICE}."
    sleep 5
  done
  printf "${SERVICE} available."
}

wait_for_it ${CONTROL_HOST_IP} 5000 '--fail --insecure https' 'Keystone'
wait_for_it ${CONTROL_HOST_IP} 9292 '--fail --insecure https' 'Glance'

ARCH=$(uname -m)
IMAGE=centos7-k8s.qcow2
IMAGE_NAME=centos7-k8s
IMAGE_TYPE=linux

# Test for credentials set
if [[ "${OS_USERNAME}" == "" ]]; then
    echo "No Keystone credentials specified.  Try running source /scripts/common/adminrc"
    exit
fi


# Upload Cirros if it isn't already available
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


