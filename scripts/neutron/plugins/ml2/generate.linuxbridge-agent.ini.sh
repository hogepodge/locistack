#!/bin/bash
set -x
cat > /etc/neutron/plugins/ml2/linuxbridge_agent.ini <<- EOF
[linux_bridge]
physical_interface_mappings = provider:${PROVIDER_INTERFACE}

[vxlan]
enable_vxlan = true
local_ip = ${PROVIDER_IP_ADDRESS}
l2_population = true

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
EOF
