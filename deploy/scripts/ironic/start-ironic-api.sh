#!/bin/bash

/scripts/ironic/initialize-keystone.sh
/scripts/ironic/initialize-imagedata.sh
/scripts/ironic/assign-temp-url-key.sh
/scripts/ironic/generate-configs.sh
/scripts/ironic/initialize-ironic-database.sh

/scripts/ironic/upload-agent.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --https :6385,/tls/openstack.crt,/tls/openstack.key \
      --wsgi-file /var/lib/openstack/bin/ironic-api-wsgi
