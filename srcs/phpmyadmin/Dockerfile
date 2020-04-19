FROM alpine

USER root

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add openrc wget lighttpd phpmyadmin php-mbstring php-gettext php7-cgi php7-mysqli php7-openssl php7-pdo php7-mcrypt php7-session php7-xml php7-zlib php7-json --no-cache

#####################################################################################################
#                               Installation of lighttpd server                                     #
#####################################################################################################
RUN sed -i '/#   include "mod_fastcgi.conf"/ s/# *//' /etc/lighttpd/lighttpd.conf
RUN sed -i 's/usr\/bin\/php-cgi/usr\/bin\/php-cgi7/g' /etc/lighttpd/mod_fastcgi.conf
RUN sed -i 's/\/run\/lighttpd.pid/\/run\/lighttpd\/php-fast-cgi.socket/g' /etc/lighttpd/lighttpd.conf
RUN sed -i '55s/^.*$/server\.document\-root\ \= \"\/usr\/share\/webapps\/phpmyadmin\"/g' /etc/lighttpd/lighttpd.conf
RUN echo "server.port = 5000" >> etc/lighttpd/lighttpd.conf
RUN mkdir /var/run/lighttpd && touch /var/run/lighttpd/php-fastcgi.socket
RUN chown -R lighttpd:lighttpd /var/run/lighttpd
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
RUN rc-update add lighttpd default

#####################################################################################################
#                                Installation of phpmyadmin                                         #
#####################################################################################################
RUN chmod -R  755 /usr/share/webapps/
RUN chmod 644 /usr/share/webapps/phpmyadmin/config.inc.php
ADD ./config.inc.php /usr/share/webapps/phpmyadmin/config.inc.php


EXPOSE 5000

CMD lighttpd -D -f /etc/lighttpd/lighttpd.conf