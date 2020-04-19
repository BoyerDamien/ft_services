#! /bin/sh
while [ ! -d /var/lib/mysql/mysql ]
do
    echo 'Database not mount'
done
echo 'Database is mount'
/usr/bin/mysqld_safe --defaults-file=/etc/mysql/my.cnf --console & wait