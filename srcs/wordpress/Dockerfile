#! /bin/sh

FROM alpine
USER root

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add openrc curl lighttpd php7-phar php7 php-mbstring php7-mysqli php7-openssl php7-pdo php7-mcrypt php7-session php7-cgi php7-xml php7-zlib php7-json --no-cache

#####################################################################################################
#                               Installation of lighttpd server                                     #
#####################################################################################################
RUN sed -i '/#   include "mod_fastcgi.conf"/ s/# *//' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/usr\/bin\/php-cgi/usr\/bin\/php-cgi7/g' /etc/lighttpd/mod_fastcgi.conf
RUN sed -i 's/\/run\/lighttpd.pid/\/run\/lighttpd\/php-fast-cgi.socket/g' /etc/lighttpd/lighttpd.conf
RUN sed -i '55s/^.*$/server\.document\-root\ \= \"\/var\/www\/wordpress\"/g' /etc/lighttpd/lighttpd.conf
RUN echo "server.port = 5050" >> /etc/lighttpd/lighttpd.conf
RUN mkdir /var/run/lighttpd && touch /var/run/lighttpd/php-fastcgi.socket
RUN chown -R lighttpd:lighttpd /var/run/lighttpd
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
RUN rc-update add lighttpd default

#####################################################################################################
#                               Installation of wordpress                                           #
#####################################################################################################
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /var/www/wordpress  && wp cli update
RUN apk add mysql mysql-client openrc --no-cache

EXPOSE 5050

CMD  lighttpd -D -f /etc/lighttpd/lighttpd.conf & wait