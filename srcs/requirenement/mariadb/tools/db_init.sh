#!/bin/bash                                                                                                                                             

echo "Starting MariaDB..."

if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "Database exists"
else
    echo "Database does not exist"
    service mariadb start
    until mariadb -e "SELECT 1"; do
        echo "waiting for mariaDB to start..."
        sleep 1
    done
    mariadb -e "CREATE DATABASE ${DB_NAME};"
    mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
    mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
    echo "MariaDB setup completed."
    service mariadb stop
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
exec mariadbd --user=mysql
