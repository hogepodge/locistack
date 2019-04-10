#!/bin/bash
set -x

/scripts/nova/generate-configs.sh
/scripts/common/wait-for-service.sh Nova 8774

nova-conductor
