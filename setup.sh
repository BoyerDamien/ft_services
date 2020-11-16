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
	minikube start --driver=virtualbox --cpus=4
else
	minikube start --driver=docker --cpus=4
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
	    phpmyadmin
            mysql
	    ftps
        )

# Install MetalLB && config
display_process_title "Installation of metallb"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl create secret generic minikube-ip --from-literal=ip=$(minikube ip)

#init nginx template
cp ./srcs/nginx/nginx_example.conf ./srcs/nginx/nginx.conf
sed -i "s|{MINIKUBE_IP}|$(minikube ip)|g" ./srcs/nginx/nginx.conf

#init pma template
cp ./srcs/phpmyadmin/config_example.inc.php ./srcs/phpmyadmin/config.inc.php
sed -i "s|{MINIKUBE_IP}|$(minikube ip)|g" ./srcs/phpmyadmin/config.inc.php

# Build docker images
display_process_title "Building docker images ... "
for image in ${IMAGES[*]}; do cd ${WORKDIR}${image} && docker build -t $image . && cd ../.. ; done

# Deployment
display_process_title "Deployment in progress"
kubectl apply -k ./srcs
