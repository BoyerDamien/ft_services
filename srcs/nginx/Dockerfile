#! /bin/sh

FROM alpine

USER root

RUN apk update && apk upgrade
RUN apk add nginx openrc openssl openssh --no-cache

# ==========================================================================================
#                                       Setup Nginx
# ==========================================================================================

RUN adduser -D -g 'www' www
RUN mkdir /www \
&& chown -R www:www /var/lib/nginx \
&& chown -R www:www /www


# ==========================================================================================
#                                    Install SSL
# ==========================================================================================
RUN mkdir -p /etc/ssl/certs && mkdir -p /etc/ssl/private \
&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=localhost' \
-keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt

EXPOSE 80 443 22 5001

ENTRYPOINT  nginx -g 'pid /tmp/nginx.pid; daemon off;'
