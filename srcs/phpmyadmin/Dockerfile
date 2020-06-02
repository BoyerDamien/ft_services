FROM alpine

USER root

#####################################################################################################
#                                       Packages intalation                                         #
#####################################################################################################
RUN apk update && apk upgrade
RUN apk add openrc wget php-mbstring php-gettext php7-cgi php7-mysqli php7-openssl php7-pdo php7-mcrypt php7-session php7-xml php7-zlib php7-json --no-cache


#####################################################################################################
#                                Installation of phpmyadmin                                         #
#####################################################################################################
RUN mkdir -p /usr/share/webapps/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.3/phpMyAdmin-4.9.3-english.tar.gz -P /tmp
RUN tar xzf /tmp/phpMyAdmin-4.9.3-english.tar.gz -C /usr/share/webapps/
RUN mv /usr/share/webapps/phpMyAdmin-4.9.3-english /usr/share/webapps/phpmyadmin
ADD ./config.inc.php /usr/share/webapps/phpmyadmin/config.inc.php
ADD ./init.sh ./init.sh
CMD sleep infinity & wait