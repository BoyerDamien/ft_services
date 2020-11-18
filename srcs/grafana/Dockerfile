#! /bin/sh

FROM alpine

RUN apk update && apk upgrade

ADD ./init.sh ./init.sh

WORKDIR /usr/share/grafana

EXPOSE 3000


CMD ["/init.sh"]
