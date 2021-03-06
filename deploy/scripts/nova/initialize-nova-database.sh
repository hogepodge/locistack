#!/bin/bash
set -x

/scripts/common/wait-for-it.sh --host=mariadb --port=3306 -t 60

# because we can't actually trust MariaDB to be ready
sleep 5

cat > /tmp/create_database.sql <<-EOF
CREATE DATABASE IF NOT EXISTS nova CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE IF NOT EXISTS nova_api CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE IF NOT EXISTS nova_cell0 CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

mysql -u root -p$MYSQL_ROOT_PASSWORD -h ${CONTROL_HOST_IP} < /tmp/create_database.sql

# Assumes that /scripts/nova/generate-configs.sh has been run 

nova-manage api_db sync
nova-manage cell_v2 map_cell0 --database_connection "mysql+pymysql://nova:$MYSQL_ROOT_PASSWORD@${CONTROL_HOST_IP}/nova_cell0?charset=utf8"
nova-manage cell_v2 create_cell --name=cell1 --verbose
nova-manage db sync
nova-manage cell_v2 list_cells
