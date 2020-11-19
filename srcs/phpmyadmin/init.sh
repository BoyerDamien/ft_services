#! /bin/bash

if [ ! -d /var/www/phpmyadmin/tmp ];
then
    apk add --no-cache phpmyadmin
    cp -rf /usr/share/webapps/phpmyadmin/* /var/www/phpmyadmin
    cp /tmp/config.inc.php /var/www/phpmyadmin
    chown -R www:www /var/www/phpmyadmin
    chmod 644 /var/www/phpmyadmin/config.inc.php
fi

php-fpm7 -F
