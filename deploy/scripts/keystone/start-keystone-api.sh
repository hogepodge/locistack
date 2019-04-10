#!/bin/bash

/scripts/common/wait-for-it.sh --host=mariadb --port=3306 -t 60

# Create the initial database user
cat > /tmp/create_database.sql <<-EOF
CREATE DATABASE IF NOT EXISTS keystone CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
       IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
       IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD -h ${CONTROL_HOST_IP} < /tmp/create_database.sql

echo ${CONTROL_HOST}

# generate the keystone and httpd configuration files
/scripts/keystone/generate.keystone.conf

# Bootstrap keystone
keystone-manage db_sync
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password $KEYSTONE_ADMIN_PASSWORD \
  --bootstrap-admin-url http://${CONTROL_HOST_IP}:35357/v3/ \
  --bootstrap-internal-url http://${CONTROL_HOST_IP}:5000/v3/ \
  --bootstrap-public-url http://${CONTROL_HOST_IP}:5000/v3/ \
  --bootstrap-region-id RegionOne


# Start uwsgi
uwsgi --uid 42424 \
      --gid 42424 \
      --http :35357 \
      --listen 1024 \
      --workers 1 \
      --thunder-lock \
      --enable-threads \
      --buffer-size 65535 \
      --wsgi-file /var/lib/openstack/bin/keystone-wsgi-admin &

uwsgi --uid 42424 \
      --gid 42424 \
      --http :5000 \
      --listen 1024 \
      --workers 1 \
      --thunder-lock \
      --enable-threads \
      --buffer-size 65535 \
      --wsgi-file /var/lib/openstack/bin/keystone-wsgi-public &

ONE=%1
TWO=%2

echo "creating endpoints"
#/scripts/keystone/initialize-endpoints.sh > endpoint_log 2>&1
#cat endpoint_log
/scripts/keystone/initialize-endpoints.sh 

wait $ONE $TWO
