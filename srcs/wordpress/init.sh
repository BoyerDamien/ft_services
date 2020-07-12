#! /bin/sh

if [ ! -f /var/www/wordpress/wp-config.php ];
then
    wp core download    --path=/var/www/wordpress
    wp config create    --dbuser=user \
					    --dbname=wordpress \
						--dbhost=mysql \
						--dbpass=password \
						--path=/var/www/wordpress
fi