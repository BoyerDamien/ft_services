#! /bin/sh

FROM alpine
VOLUME [ "/sys/fs/cgroup/" ]

RUN apk update && apk upgrade
RUN apk add --no-cache nginx openrc openssl openssh
RUN adduser -D www
# ==========================================================================================
#                                    Install SSL
# ==========================================================================================
RUN mkdir -p /etc/ssl/certs && mkdir -p /etc/ssl/private \
&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=ft_services' \
-keyout /etc/ssl/private/ft_services.key -out /etc/ssl/certs/ft_services.crt

RUN openrc && touch /run/openrc/softlevel
RUN rc-update add nginx default

RUN rc-service nginx restart

EXPOSE 80 443 22

CMD nginx -g 'pid /tmp/nginx.pid; daemon off;'
