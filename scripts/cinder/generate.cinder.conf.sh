#!/bin/bash

cat > /etc/cinder/cinder.conf <<- EOF
[DEFAULT]

my_ip = ${CONTROL_HOST_IP}
host = ${CONTROL_HOST}

log-dir = /var/log/cinder
state_path = /var/lib/cinder

transport_url = rabbit://guest:${RABBITMQ_DEFAULT_PASS}@${CONTROL_HOST}

auth_strategy = keystone

enabled_backends = lvm

[database]

connection = mysql+pymysql://cinder:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/cinder
max_pool_size = 200
max_overflow = 300

[keystone_authtoken]

www_authenticate_uri = https://${CONTROL_HOST_IP}:5000
auth_url = https://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = cinder
password = ${SERVICE_PASSWORD}
insecure = true

[oslo_concurrency]

lock_path = /var/lib/cinder/tmp

[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm

EOF
