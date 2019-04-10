#!/bin/bash
set -x

mkdir -p /etc/placement

/scripts/placement/generate.placement.conf.sh
/scripts/placement/initialize-placement-database.sh

/scripts/placement/initialize-keystone.sh

placement-api
