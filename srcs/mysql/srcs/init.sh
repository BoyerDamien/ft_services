#! /bin/sh
if [ ! -d /var/lib/mysql/mysql ]
then
    mysql_install_db --user=root --datadir=/var/lib/mysql
    rc-service mariadb start 
    mysqladmin -u root password 'password'
    mysqladmin -u root create wordpress
    mysql -u root < ./table.sql
fi