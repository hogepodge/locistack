#!/bin/bash
set -x
/scripts/glance/generate.glance-api.conf
/scripts/glance/generate.glance-registry.conf
/scripts/glance/initialize-glance-database.sh
