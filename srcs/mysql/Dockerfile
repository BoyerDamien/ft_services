FROM alpine

USER root

VOLUME [ "/sys/fs/cgroup/" ]

RUN apk update && apk upgrade
RUN apk add mysql mysql-client openrc --no-cache

RUN mkdir /run/openrc && touch /run/openrc/softlevel
RUN sed -i 's/skip-networking/#skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
RUN /usr/bin/mysql_install_db --user=mysql --datadir="/var/lib/mysql"

#ADD ./srcs/my.cnf /etc/mysql/my.cnf
#RUN chown mysql:mysql /etc/mysql/my.cnf && chmod 600 /etc/mysql/my.cnf

#RUN mysql_install_db --user=root --datadir=/var/lib/mysql
#RUN touch /var/lib/mysql/mysql.sock

ADD ./srcs/wordpress.sql /tmp/wordpress.sql
RUN openrc && rc-service mariadb start && mysql < /tmp/wordpress.sql
RUN rm /tmp/wordpress.sql

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT mysqld_safe --datadir="/var/lib/mysql"

