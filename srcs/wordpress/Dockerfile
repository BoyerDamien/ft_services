#! /bin/sh

FROM php-fpm

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add --no-cache openrc curl php7-phar php7 mysql mysql-client
RUN sed -i "s|listen = 127.0.0.1:9000|listen = 5050|g" /etc/php7/php-fpm.d/www.conf
ADD ./init.sh ./init.sh

#####################################################################################################
#                               Installation of wordpress                                           #
#####################################################################################################
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update

EXPOSE 5050

CMD php-fpm7 -F