#! /bin/sh

FROM alpine
USER root

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add openrc curl lighttpd php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom --no-cache 

#####################################################################################################
#                               Installation of lighttpd server                                     #
#####################################################################################################
RUN sed -i '/#   include "mod_fastcgi.conf"/ s/# *//' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/usr\/bin\/php-cgi/usr\/bin\/php-cgi7/g' /etc/lighttpd/mod_fastcgi.conf
RUN sed -i 's/\/run\/lighttpd.pid/\/run\/lighttpd\/php-fast-cgi.socket/g' /etc/lighttpd/lighttpd.conf
RUN mkdir /var/run/lighttpd && touch /var/run/lighttpd/php-fastcgi.socket
RUN chown -R lighttpd:lighttpd /var/run/lighttpd
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
RUN rc-update add lighttpd default

#####################################################################################################
#                               Installation of wordpress                                           #
#####################################################################################################
RUN mkdir -p /var/www/
RUN curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz && mv ./wordpress ./var/www
ADD ./srcs/wp-config.php /var/www/wordpress/wp-config.php
RUN chown -R lighttpd /var/www/
RUN chmod 755 -R /var/www
RUN ln -s /var/www/wordpress/ /var/www/localhost/htdocs/wordpress
RUN rm latest.tar.gz

EXPOSE 80

CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf