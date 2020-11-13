#! /bin/sh
if [ ! -d /var/lib/mysql/mysql ]
then
    mysql_install_db --user=root --datadir=/var/lib/mysql
    rc-service mariadb start 
    mysqladmin -u root password 'password'
    mysqladmin -u root create wordpress
    sed -i "s|{DB_USER}|$DB_USER|g" ./table.sql
    sed -i "s|{DB_PASSWORD}|$DB_PASSWORD|g" ./table.sql
    sed -i "s|{DB_NAME}|$DB_NAME|g" ./table.sql
    mysql -u root < ./table.sql
fi
