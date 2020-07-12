#! /bin/sh

FROM alpine

RUN apk update && apk upgrade
RUN apk add --no-cache grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

WORKDIR /usr/share/grafana

EXPOSE 3000

CMD /usr/sbin/grafana-server --config=/etc/grafana.ini