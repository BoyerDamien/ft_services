#! /bin/sh
if [ -d "/var/lib/mysql/mysql" ]
then
    echo 'SQL database already exists'
    rm /run/mysqld/mysqld.sock
else
    echo 'Create database'
    mysql_install_db --user=root --datadir=/var/lib/mysql
    rc-service mariadb start
    mysqladmin -u root password 'password'
    mysqladmin -u root create wordpress
    mysql < /tmp/wordpress.sql
    rc-service mariadb stop
fi
/usr/bin/mysqld_safe --defaults-file=/etc/mysql/my.cnf --console & wait