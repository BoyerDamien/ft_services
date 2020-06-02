#! /bin/sh

FROM alpine
VOLUME [ "/sys/fs/cgroup/" ]
USER root

RUN apk update && apk upgrade
RUN apk add nginx openrc openssl openssh php7-session php-mbstring php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype --no-cache

# ==========================================================================================
#                                    Install SSL
# ==========================================================================================
RUN mkdir -p /etc/ssl/certs && mkdir -p /etc/ssl/private \
&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=ft_services' \
-keyout /etc/ssl/private/ft_services.key -out /etc/ssl/certs/ft_services.crt

RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = root|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|;listen.group\s*=\s*nobody|listen.group = root|g" /etc/php7/php-fpm.d/www.conf

RUN openrc && touch /run/openrc/softlevel
RUN rc-update add nginx default
RUN rc-update add php-fpm7 default
RUN rc-service php-fpm7 restart
RUN rc-service nginx restart

EXPOSE 80 443 22

ENTRYPOINT rc-service php-fpm7 restart && nginx -g 'pid /tmp/nginx.pid; daemon off;'