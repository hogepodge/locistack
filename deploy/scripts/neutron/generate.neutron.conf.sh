#!/bin/bash
set -x
cat > /etc/neutron/neutron.conf <<- EOF
[DEFAULT]

core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true

transport_url = rabbit://guest:${RABBITMQ_DEFAULT_PASS}@${CONTROL_HOST}

auth_strategy = keystone

notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

bind_port = 9696
host = ${CONTROL_HOST}
#nova_metadata_ip = ${CONTROL_HOST_IP}
metadata_proxy_shared_secret = ${METADATA_SECRET}
api_workers = 1

debug = ${NEUTRON_DEBUG}

[database]
connection = mysql+pymysql://neutron:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/neutron
max_pool_size=200
max_overflow=300

[keystone_authtoken]

www_authenticate_uri = http://${CONTROL_HOST_IP}:5000
auth_url = http://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = ${SERVICE_PASSWORD}

[nova]
auth_url = http://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = nova
password = ${SERVICE_PASSWORD}

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

[privsep]
helper_command=/var/lib/openstack/bin/neutron-rootwrap /etc/neutron/rootwrap.conf privsep-helper
EOF
