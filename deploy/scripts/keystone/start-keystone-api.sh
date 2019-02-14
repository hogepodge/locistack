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
  --bootstrap-admin-url https://${CONTROL_HOST_IP}:35357/v3/ \
  --bootstrap-internal-url https://${CONTROL_HOST_IP}:5000/v3/ \
  --bootstrap-public-url https://${CONTROL_HOST_IP}:5000/v3/ \
  --bootstrap-region-id RegionOne

# Start uwsgi
uwsgi --uid 42424 --gid 42424 --https :35357,/tls/openstack.crt,/tls/openstack.key --wsgi-file /var/lib/openstack/bin/keystone-wsgi-admin &
uwsgi --uid 42424 --gid 42424 --https :5000,/tls/openstack.crt,/tls/openstack.key --wsgi-file /var/lib/openstack/bin/keystone-wsgi-public &
wait %1 %2