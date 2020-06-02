#! /bin/sh

if [ ! -d /var/www/phpmyadmin/tmp ];
then
    mkdir /usr/share/webapps/phpmyadmin/tmp
    chmod 777 /usr/share/webapps/phpmyadmin/tmp
fi
cd /usr/share/webapps/phpmyadmin/ && cp -rf * /var/www/phpmyadmin
