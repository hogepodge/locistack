#!/bin/bash
set -x

mkdir -p /etc/placement
/scripts/placement/generate.placement.conf.sh
/scripts/placement/initialize-placement-database.sh

/scripts/common/wait-for-service.sh Keystone 5000

placement-api
