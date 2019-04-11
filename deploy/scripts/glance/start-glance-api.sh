#!/bin/bash
set -x

cp /scripts/glance/glance-api-paste.ini /etc/glance/glance-api-paste.ini
cp /scripts/glance/glance-registry-paste.ini /etc/glance/glance-registry-paste.ini

/scripts/glance/initialize-keystone.sh
until $(curl --output /dev/null --silent http://${CONTROL_HOST}:8888); do
    printf "Waiting on Swift"
    sleep 5
done

/scripts/glance/generate.glance-api.conf
/scripts/glance/generate.glance-swift.conf
/scripts/glance/initialize-glance-database.sh

uwsgi --uid 42424 \
      --gid 42424 \
      --http :9292 \
      --http-chunked-input \
      --http-auto-chunked \
      --wsgi-file /var/lib/openstack/bin/glance-wsgi-api
