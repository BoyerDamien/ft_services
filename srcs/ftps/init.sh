#! /bin/sh

MINIKUBE_IP=$(cat /var/www/hosts.txt | grep minikube | awk '{print $1}')
echo "pasv_address=$MINIKUBE_IP" >> /etc/vsftpd/vsftpd.conf
vsftpd /etc/vsftpd/vsftpd.conf
