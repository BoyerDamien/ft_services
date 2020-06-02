FROM alpine

VOLUME [ "/sys/fs/cgroup/" ]

USER root

RUN apk update && apk upgrade
RUN apk add mysql mysql-client openrc --no-cache

ADD ./srcs/start.sh ./start.sh
ADD srcs/my.cnf /etc/mysql/my.cnf
ADD ./srcs/table.sql ./table.sql
ADD ./srcs/init.sh ./init.sh

RUN mkdir /run/openrc && touch /run/openrc/softlevel

RUN openrc

EXPOSE 3306

CMD ./start.sh