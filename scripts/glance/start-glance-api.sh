#!/bin/bash
set -x

chown -R 42424:42424 /images

cp /scripts/glance/glance-api-paste.ini /etc/glance/glance-api-paste.ini
cp /scripts/glance/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini

/scripts/glance/initialize-keystone.sh
/scripts/glance/initialize-glance.sh

uwsgi --uid 42424 --gid 42424 --https :9292,/tls/openstack.crt,/tls/openstack.key --wsgi-file /var/lib/openstack/bin/glance-wsgi-api
