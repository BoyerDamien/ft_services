#! /bin/sh

FROM php-fpm

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add --no-cache openrc curl php7-phar php7 mysql mysql-client

#####################################################################################################
#                               Installation of wordpress                                           #
#####################################################################################################

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update

EXPOSE 9000

ADD ./init.sh ./init.sh

CMD ["./init.sh"]
