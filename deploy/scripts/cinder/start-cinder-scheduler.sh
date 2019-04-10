#!/bin/bash
set -x

/scripts/cinder/generate-configs.sh
/scripts/common/wait-for-service.sh Cinder 8776

/var/lib/openstack/bin/cinder-scheduler
