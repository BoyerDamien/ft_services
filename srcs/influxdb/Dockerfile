#! /bin/sh

FROM alpine
VOLUME [ "/sys/fs/cgroup/" ]

RUN apk update && apk upgrade
RUN apk add --no-cache influxdb openrc
RUN apk add --no-cache telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN openrc && touch /run/openrc/softlevel

EXPOSE 8086

#CMD rc-service telegraf start & influxd