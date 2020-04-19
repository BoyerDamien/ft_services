#! /usr/bin/bash

# ================================================================================
#                                       Functions
# ================================================================================

display_process_title ()
{
    echo '========================================================================'
    echo '                               '$1
    echo '========================================================================'
}

# ================================================================================
#                                       Main
# ================================================================================

# Global variables
WORKDIR='./srcs/'
IMAGES=(
            nginx
            wordpress
            mysql
            phpmyadmin
        )
WORDPRESS_ADMIN='root'
WORDPRESS_PASSWORD='password'
WORDPRESS_MAIL='damienboyer45@gmail.com'
DB_NAME='wordpress'
DB_HOST='0.0.0.0:3306'


minikube addons enable ingress

# Create volumes
display_process_title "Creating volumes"
kubectl apply -k ${WORKDIR}volumes/

# Build docker images
display_process_title "Building docker images ... "
for image in ${IMAGES[*]}; do cd ${WORKDIR}${image} && docker build -t $image . && cd ../.. ; done

# Create services
display_process_title "Creating services"
kubectl apply -k ${WORKDIR}services/

# Create deployment
display_process_title "Creating deployments"
kubectl apply -k ${WORKDIR}deployments/

# Test pods readiness
display_process_title "Test if pods are ready ..."
first=1
two=2

while [  $first != $two ]
do
    kubectl get pods -o wide
    first=$(kubectl get pods | grep wordpress | cut -d\  -f4 | cut -d/ -f1)
    two=$(kubectl get pods | grep wordpress | cut -d\  -f4 | cut -d/ -f2)
done

display_process_title "Pods are ready"


# Install database
display_process_title "Installation of the database" && sleep 5s
mysql_id=$(docker ps | grep mysql | cut -d\  -f1)
docker exec $mysql_id mysql_install_db --user=root --datadir=/var/lib/mysql
docker exec $mysql_id rc-service mariadb start 
docker exec $mysql_id mysqladmin -u root password 'password'
docker exec $mysql_id mysqladmin -u root create wordpress
docker exec $mysql_id rc-service mariadb stop

# Install wordpress
display_process_title "Installation of wordpress"
wordpress_id=$(docker ps | grep wordpress_wordpress | cut -d\  -f1)
docker exec $wordpress_id wp core download --path=/var/www/wordpress
docker exec $wordpress_id wp config create --dbuser=$WORDPRESS_ADMIN --dbname=$DB_NAME --dbhost=$DB_HOST --dbpass=$WORDPRESS_PASSWORD --path=/var/www/wordpress
docker exec $wordpress_id wp core install --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_PASSWORD --admin_email=$WORDPRESS_MAIL --path=/var/www/wordpress --url=$(minikube service wordpress --url) --title=ft_services

# Install phpmyadmin
display_process_title 'Installation of phpmyadmin'
phpmyadmin_id=$(docker ps | grep phpmyadmin | cut -d\  -f1)
docker exec $phpmyadmin_id echo "$cfg['PmaAbsoluteUri'] = "$(minikube service phpmyadmin --url)";">>/usr/share/webapps/phpmyadmin/config.inc.php


