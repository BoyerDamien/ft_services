#! /bin/bash

# ================================================================================
#                                 Functions
# ================================================================================

display_process_title ()
{
    echo '========================================================================'
    echo '                               '$1
    echo '========================================================================'
}
# ================================================================================
# 				Install minikube
# ================================================================================

if [[ $(uname) -eq "Darwin" ]] && [[ ! $(command -v minikube) ]]
then
	echo "Mac os detected! Minikube is not installed. Installing now ..."
	brew install minikube
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
	minikube start --driver=virtualbox
else
	minikube start --driver=docker
fi

# Launch minikube env
eval $(minikube docker-env)

# ================================================================================
#                                       Main
# ================================================================================

# Global variables
WORKDIR='./srcs/'
IMAGES=(
            php-fpm
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

# Install MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

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

# Install wordpress
display_process_title "Installation of wordpress"
wordpress_id=$(docker ps | grep wordpress_wordpress | cut -d\  -f1)

#docker exec $wordpress_id wp core install 	--admin_user=$WORDPRESS_ADMIN \
#											--admin_password=$WORDPRESS_PASSWORD \
#											--admin_email=info@example.com \
#											--path=/var/www/wordpress \
#											--url=http://$(minikube ip)/wordpress/ \
#											--title=ft_services --skip-email
