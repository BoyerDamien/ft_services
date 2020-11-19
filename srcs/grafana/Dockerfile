#! /bin/sh

FROM alpine

RUN apk update && apk upgrade

ADD ./dashboard1.json /dashboard1.json
ADD ./dashboard1.yaml /dashboard1.yaml
ADD ./init.sh ./init.sh

WORKDIR /usr/share/grafana

EXPOSE 3000


CMD ["/init.sh"]
