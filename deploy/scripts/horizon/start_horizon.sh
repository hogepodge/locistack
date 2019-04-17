#!/bin/bash

/scripts/horizon/generate.local_settings.py.sh
chown root:apache /etc/openstack-dashboard/local_settings
httpd -k start

sleep infinity
