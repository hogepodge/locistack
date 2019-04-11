#!/bin/bash

/scripts/ironic/initialize-keystone.sh
/scripts/common/wait-for-service.sh Cinder 8776
/scripts/common/wait-for-service.sh Glance 9292

/scripts/ironic/initialize-imagedata.sh
/scripts/ironic/assign-temp-url-key.sh
/scripts/ironic/generate-configs.sh
/scripts/ironic/initialize-ironic-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --http :6385 \
      --wsgi-file /var/lib/openstack/bin/ironic-api-wsgi
