#! /bin/sh

if [ ! -f /var/www/wordpress/wp-config.php ];
then
	MINIKUBE_IP=$(cat /var/www/hosts.txt | grep minikube | awk '{print $1}')
	wp core download    --path=/var/www/wordpress
	wp config create    --dbuser=$DB_USER \
		--dbname=$DB_NAME \
		--dbhost=$DB_HOST \
		--dbpass=$DB_PASSWORD \
		--path=/var/www/wordpress
	
	wp core install --path=/var/www/wordpress\
		--url="http://$MINIKUBE_IP:30050"\
		--title=ft_services\
		--admin_user=test\
		--admin_password=test\
		--admin_email=test@example.com

	wp user create bob bob@example.com --role=author --user_pass=bob --path=/var/www/wordpress
	wp user create tom tom@example.com --role=author --user_pass=tom --path=/var/www/wordpress
fi

php-fpm7 -F
