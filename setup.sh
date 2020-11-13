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
        )

# Install MetalLB
display_process_title "Installation of metallb"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# Build docker images
display_process_title "Building docker images ... "
for image in ${IMAGES[*]}; do cd ${WORKDIR}${image} && docker build -t $image . && cd ../.. ; done

# Create services
display_process_title "Deployment in progress"
kubectl apply -k ./srcs

# Install wordpress
display_process_title "Installation of wordpress"

#docker exec $wordpress_id wp core install 	--admin_user=$WORDPRESS_ADMIN \
#											--admin_password=$WORDPRESS_PASSWORD \
#											--admin_email=info@example.com \
#											--path=/var/www/wordpress \
#											--url=http://$(minikube ip)/wordpress/ \
#											--title=ft_services --skip-email
