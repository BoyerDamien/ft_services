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
            ftps
        )
WORDPRESS_ADMIN='user'
WORDPRESS_PASSWORD='password'
DB_NAME='wordpress'
DB_HOST='mysql'
#CERT_NAME='ft_services_ssl'
#KEY_FILE='./srcs/ssl/ft_services.key'
#CERT_FILE='./srcs/ssl/ft_services.crt'


minikube addons enable ingress

# Create volumes
display_process_title "Creating volumes"
kubectl apply -k ${WORKDIR}volumes/

#kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}

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
    first=$(kubectl get pods | grep mysql | cut -d\  -f11 | cut -d/ -f1)
    echo $first
    two=$(kubectl get pods | grep mysql | cut -d\  -f11 | cut -d/ -f2)
done

# Install wordpress
display_process_title "Installation of wordpress"
wordpress_id=$(docker ps | grep wordpress_wordpress | cut -d\  -f1)
docker exec $wordpress_id wp core download --path=/var/www/wordpress
docker exec $wordpress_id wp config create --dbuser=$WORDPRESS_ADMIN --dbname=$DB_NAME --dbhost=$DB_HOST --dbpass=$WORDPRESS_PASSWORD --path=/var/www/wordpress
docker exec $wordpress_id wp core install --admin_user=$WORDPRESS_ADMIN --admin_password=$WORDPRESS_PASSWORD --admin_email=info@example.com --path=/var/www/wordpress --url=http://$(minikube ip)/wordpress/ --title=ft_services --skip-email