#! /bin/sh

if [ ! -f /var/www/wordpress/wp-config.php ];
then
	wp core download    --path=/var/www/wordpress
	wp config create    --dbuser=$DB_USER \
		--dbname=$DB_NAME \
		--dbhost=$DB_HOST \
		--dbpass=$DB_PASSWORD \
		--path=/var/www/wordpress
fi
