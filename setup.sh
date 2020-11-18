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

if [[ ! $(command -v minikube) ]]
then 
	echo "Linux detected! Minikube is not installed. Installing now ..."
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
	if [[ $? != 0 ]]
	then
		echo "Error: cannot download minikube ..."
		exit 1
	fi
	sudo mkdir -p /usr/local/bin/
	sudo install minikube /usr/local/bin/
fi

if [[ $(command -v minikube ) ]]
then
	echo "Minikube is installed"
else
	echo "Error: minikube is not installed"
	exit 1
fi

if [[ ! -d ~/.minikube/machines/minikube ]]
then
	display_process_title "Starting Minikube"
	# Start minikube
	minikube start --driver=virtualbox --cpus=6

	# Check if minikube has started
	if [[ $? != 0 ]]
	then
		echo "Error: cannot start minikube..."
		exit 1
	fi
fi

# Launch minikube env
display_process_title "Retrieving minikube docker env"
eval $(minikube docker-env)

if [[ $? != 0 ]]
then
	echo "Error: cannot retriev minikube docker env"
	exit 1
fi

# Global variables
WORKDIR='./srcs/'
IMAGES=(
	php-fpm
	nginx
	wordpress
	phpmyadmin
	mysql
	ftps
	influxdb
	grafana
)

# Install MetalLB && config
display_process_title "Installation of metallb"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

display_process_title "Create some important secrets"
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl create secret generic minikube-ip --from-literal=ip=$(minikube ip)

#init nginx template
display_process_title "Initialize some important templates"
cp ./srcs/nginx/nginx_example.conf ./srcs/nginx/nginx.conf
sed -i "s|{MINIKUBE_IP}|$(minikube ip)|g" ./srcs/nginx/nginx.conf

#init pma template
cp ./srcs/phpmyadmin/config_example.inc.php ./srcs/phpmyadmin/config.inc.php
sed -i "s|{MINIKUBE_IP}|$(minikube ip)|g" ./srcs/phpmyadmin/config.inc.php

# Build docker images
display_process_title "Building docker images ... "
for image in ${IMAGES[*]}
do 
	docker build -t ${image} ./srcs/${image}; 
	if [[ $? != 0 ]]
	then
		echor "Error: cannot build image for ${image}"
		exit 1
	fi
done

# Deployment
display_process_title "Deployment in progress..."
kubectl apply -k ./srcs
