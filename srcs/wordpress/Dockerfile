#! /bin/sh

FROM alpine
USER root

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add openrc curl php7-phar php7 php-mbstring php7-mysqli php7-openssl php7-pdo php7-mcrypt php7-session php7-cgi php7-xml php7-zlib php7-json --no-cache

#####################################################################################################
#                               Installation of wordpress                                           #
#####################################################################################################
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /var/www/wordpress  && wp cli update
RUN apk add mysql mysql-client openrc --no-cache

CMD  sleep infinity & wait