FROM alpine

USER root

RUN apk update && apk upgrade
RUN apk add mysql mysql-client openrc --no-cache

RUN mysql_install_db --user=root --datadir=/var/lib/mysql
ADD ./srcs/my.cnf /etc/mysql/my.cnf
ADD ./srcs/wordpress.sql /tmp/wordpress.sql
RUN mkdir /run/openrc && touch /run/openrc/softlevel
RUN openrc && rc-service mariadb start && mysql < /tmp/wordpress.sql
RUN rm /tmp/wordpress.sql

VOLUME [ "/var/lib/mysql" ]

EXPOSE 2000

CMD mysqld

