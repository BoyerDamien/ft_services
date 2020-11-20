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

# Delete existing cluster
display_process_title "Delete existing cluster"
minikube delete

if [[ ! -d ~/.minikube/machines/minikube ]]
then

	display_process_title "Starting Minikube"
	
	# Start minikube
	minikube start --driver=docker\
		       --memory=3000\
		       --cpus=3\
		       --disk-size=21000

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
kubectl create secret generic minikube-ip --from-literal=ip="$(minikube ip)"

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

#Expose loadbalancer
display_process_title "Services"
kubectl get svc

display_process_title "Pods"
kubectl get pods

display_process_title "Minikube ip"
minikube ip
