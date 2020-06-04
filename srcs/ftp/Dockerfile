FROM alpine

VOLUME [ "/sys/fs/cgroup/" ]

USER root

RUN apk update && apk upgrade
RUN apk add vsftpd --no-cache
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
RUN adduser -D user && passwd user -d 'password'

EXPOSE 21

CMD vsftpd /etc/vsftpd/vsftpd.conf & wait
