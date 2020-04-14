FROM alpine

VOLUME [ "/sys/fs/cgroup/" ]

USER root

RUN apk update && apk upgrade
RUN apk add mysql mysql-client openrc --no-cache

ADD ./start.sh ./start.sh
ADD ./srcs/wordpress.sql /tmp/wordpress.sql
ADD srcs/my.cnf /etc/mysql/my.cnf

RUN mkdir /run/openrc && touch /run/openrc/softlevel

RUN openrc
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

CMD ./start.sh