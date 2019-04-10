#!/bin/bash
set -x

/scripts/common/wait-for-it.sh --host=mariadb --port=3306 -t 60

# because we can't actually trust MariaDB to be ready
sleep 5

cat > /tmp/create_database.sql <<-EOF
CREATE DATABASE IF NOT EXISTS cinder CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD -h ${CONTROL_HOST_IP} < /tmp/create_database.sql

cinder-manage db sync
