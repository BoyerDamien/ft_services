#! /bin/sh

cp /etc/nginx/nginx_example.conf /etc/nginx/nginx.conf
sed -i "s|{MINIKUBE_IP}|$MINIKUBE_IP|g" /etc/nginx/nginx.conf
