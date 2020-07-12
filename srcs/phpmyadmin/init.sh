#! /bin/bash

if [ ! -d /var/www/phpmyadmin/tmp ];
then
    cp -rf /usr/share/webapps/phpmyadmin/* /var/www/phpmyadmin
    cp /tmp/config.inc.php /var/www/phpmyadmin
    chown -R www:www /var/www/phpmyadmin
    chmod 644 /var/www/phpmyadmin/config.inc.php
fi
