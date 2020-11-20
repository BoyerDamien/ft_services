#! /bin/sh

echo "pasv_address=$MINIKUBE_IP" >> /etc/vsftpd/vsftpd.conf
vsftpd /etc/vsftpd/vsftpd.conf
