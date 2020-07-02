#! /bin/bash

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
# 									Install minikube
# ================================================================================

if [[ $(uname) -eq "Darwin" ]] && [[ ! $(command -v minikube) ]]
then
	echo "Mac os detected! Minikube is not installed. Installing now ..."
	brew install minikube
	brew install cask
	brew cask install virtualbox
elif [[ $(uname) -ne "Darwin" ]] && [[ ! $(command -v minikube) ]]
then 
	echo "Linux detected! Minikube is not installed. Installing now ..."
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
fi

if [[ $(command -v minikube ) ]]
then
	echo "Minikube is installed"
else
	echo "Error minikube is not installed"
	exit 1
fi

if [[ $(uname) -eq "Darwin" ]]
then 
	minikube start
else [[ $(uname) -ne "Darwin" ]]
	minikube start --driver=docker
fi

# Launc minikube env
eval $(minikube docker-env)

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
    first=$(kubectl get pods | grep mysql | cut -d\  -f11 | cut -d/ -f1)
    echo $first
    two=$(kubectl get pods | grep mysql | cut -d\  -f11 | cut -d/ -f2)
done

# Install wordpress
display_process_title "Installation of wordpress"
wordpress_id=$(docker ps | grep wordpress_wordpress | cut -d\  -f1)
docker exec $wordpress_id wp core download --path=/var/www/wordpress
docker exec $wordpress_id wp config create 	--dbuser=$WORDPRESS_ADMIN \
											--dbname=$DB_NAME \
											--dbhost=$DB_HOST \
											--dbpass=$WORDPRESS_PASSWORD \
											--path=/var/www/wordpress
docker exec $wordpress_id wp core install 	--admin_user=$WORDPRESS_ADMIN \
											--admin_password=$WORDPRESS_PASSWORD \
											--admin_email=info@example.com \
											--path=/var/www/wordpress \
											--url=http://$(minikube ip)/wordpress/ \
											--title=ft_services --skip-email
