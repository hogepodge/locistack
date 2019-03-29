#!/bin/bash

source /scripts/ironic/glancerc

openstack object store account set --property Temp-Url-Key=${IRONIC_TEMP_URL_KEY}
