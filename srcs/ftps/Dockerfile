FROM alpine

VOLUME [ "/sys/fs/cgroup/" ]

USER root

RUN apk update && apk upgrade
RUN apk add vsftpd openssl --no-cache

RUN sed -i "s|anonymous_enable=YES|anonymous_enable=NO|g" /etc/vsftpd/vsftpd.conf
RUN sed -i "s|#local_enable=YES|local_enable=YES|g" /etc/vsftpd/vsftpd.conf
RUN sed -i "s|#write_enable=YES|write_enable=YES|g" /etc/vsftpd/vsftpd.conf
RUN sed -i "s|#local_umask=077|local_umask=077|g" /etc/vsftpd/vsftpd.conf
RUN echo "vsftpd_log_file=/proc/1/fd/1" >> /etc/vsftpd/vsftpd.conf
RUN echo "ftpd_banner=Welcome ft_services ftps server" >> /etc/vsftpd/vsftpd.conf
RUN echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf
RUN echo "pasv_enable=Yes" >> /etc/vsftpd/vsftpd.conf
RUN echo "pasv_promiscuous=YES" >> /etc/vsftpd/vsftpd.conf
RUN echo "pasv_address=172.17.0.2" >> /etc/vsftpd/vsftpd.conf
RUN echo "background=NO" >> /etc/vsftpd/vsftpd.conf

################################################################
#                        SSL Configuration
################################################################
RUN mkdir -p /etc/ssl/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=ft_services' \
-keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
RUN echo "ssl_enable=YES" >> /etc/vsftpd/vsftpd.conf
RUN echo "allow_anon_ssl=NO" >> /etc/vsftpd/vsftpd.conf
RUN echo "force_local_data_ssl=YES" >> /etc/vsftpd/vsftpd.conf
RUN echo "force_local_logins_ssl=YES" >> /etc/vsftpd/vsftpd.conf
RUN echo "ssl_tlsv1=NO" >> /etc/vsftpd/vsftpd.conf
RUN echo "ssl_sslv2=NO" >> /etc/vsftpd/vsftpd.conf
RUN echo "ssl_sslv3=NO" >> /etc/vsftpd/vsftpd.conf
RUN echo "require_ssl_reuse=YES" >> /etc/vsftpd/vsftpd.conf
RUN echo "ssl_ciphers=HIGH" >> /etc/vsftpd/vsftpd.conf
RUN echo "rsa_cert_file=/etc/ssl/certs/vsftpd.crt" >> /etc/vsftpd/vsftpd.conf
RUN echo "rsa_private_key_file=/etc/ssl/private/vsftpd.key" >> /etc/vsftpd/vsftpd.conf

################################################################
#                        USER CREATION
################################################################
RUN adduser -D user && passwd user -d 'password'

EXPOSE 21

CMD vsftpd /etc/vsftpd/vsftpd.conf
