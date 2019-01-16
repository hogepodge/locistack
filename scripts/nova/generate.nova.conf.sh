#!/bin/bash
cat > /etc/nova/nova.conf <<- EOF
[DEFAULT]

debug = ${NOVA_DEBUG}

enabled_apis = osapi_compute,metadata
my_ip = ${CONTROL_HOST_IP}
host = ${CONTROL_HOST}

log-dir = /var/log/nova
state_path = /var/lib/nova
#lock_path = /var/lock/nova
# rootwrap_config = /etc/nova/rootwrap.conf

compute_scheduler_driver = nova.scheduler.filter_scheduler.FilterScheduler
ram_allocation_ratio = 1.0
reserved_host_memory_mb = 0
scheduler_tracks_instance_changes = False

osapi_compute_workers = 1
metadata_workers = 1

compute_driver = libvirt.LibvirtDriver
api_paste_config = /etc/nova/api-paste.ini

# instance_name_template=baremetal-%08x

allow_resize_to_same_host = False

transport_url = rabbit://guest:${RABBITMQ_DEFAULT_PASS}@${CONTROL_HOST}

use_neutron = True
firewall_driver=nova.virt.firewall.NoopFirewallDriver

reserved_host_memory_size_mb=0

# NOVNC CONSOLE
#novncproxy_base_url=http://192.168.206.130:6080/vnc_auto.html
# Change vncserver_proxyclient_address and vncserver_listen to match each compute host
#vncserver_proxyclient_address=192.168.206.130
#vncserver_listen=192.168.206.130

# AUTHENTICATION

auth_strategy = keystone

[api]

auth_strategy = keystone

[keystone_authtoken]

www_authenticate_uri = https://${CONTROL_HOST_IP}:5000
auth_url = https://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = ${SERVICE_PASSWORD}
insecure = true

[glance]

api_servers = https://${CONTROL_HOST_IP}:9292

[database]

connection = mysql+pymysql://nova:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/nova
max_pool_size = 200
max_overflow = 300

[api_database]

connection = mysql+pymysql://nova:${MYSQL_ROOT_PASSWORD}@${CONTROL_HOST_IP}/nova_api
max_pool_size = 200
max_overflow = 300

[oslo_concurrency]

lock_path = /var/lib/nova/tmp

[placement]

auth_type = password
auth_url = https://${CONTROL_HOST_IP}:5000/v3
project_name = service
username = placement
password = ${SERVICE_PASSWORD}
os_region_name = RegionOne
project_domain_name = Default
user_domain_name = Default
insecure = true

[workaround]
disable_rootwrap = True

[filter_scheduler]
track_instance_changes=False

[scheduler]
discover_hosts_in_cells_interval=120

[neutron]
url = http://${CONTROL_HOST_IP}:9696
auth_url = https://${CONTROL_HOST_IP}:5000
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = ${SERVICE_PASSWORD}
service_metadata_proxy = true
metadata_proxy_shared_secret = ${METADATA_SECRET}
insecure = true

[conductor]

workers = 1

EOF
