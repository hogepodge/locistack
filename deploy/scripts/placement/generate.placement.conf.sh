#!/bin/bash
cat > /etc/placement/placement.conf <<- EOF
[DEFAULT]

debug = ${NOVA_DEBUG}

[api]

auth_strategy = keystone

[keystone_authtoken]

www_authenticate_uri = http://${CONTROL_HOST_IP}:5000
auth_url = http://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = ${SERVICE_PASSWORD}

[placement_database]

connection = mysql+pymysql://placement:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/placement
max_pool_size = 200
max_overflow = 300

[oslo_concurrency]

lock_path = /var/lib/nova/tmp

EOF
