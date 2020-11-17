#  /bin/sh

FROM alpine
VOLUME [ "/sys/fs/cgroup/" ]

ADD ./init.sh ./init.sh
ADD ./telegraf.conf ./telegraf.conf

RUN apk update && apk upgrade
RUN apk add --no-cache openrc curl wget gnupg musl
RUN openrc && touch /run/openrc/softlevel

RUN  curl -s https://repos.influxdata.com/influxdb2.key | gpg --import -
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-2.0.1_linux_amd64.tar.gz
RUN tar xvzf influxdb-2.0.1_linux_amd64.tar.gz
RUN cp ./influxdb-2.0.1_linux_amd64/influx /usr/local/bin/
RUN cp ./influxdb-2.0.1_linux_amd64/influxd /usr/local/bin/

RUN wget http://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/telegraf-1.16.2-r0.apk
RUN apk add --upgrade telegraf-1.16.2-r0.apk


EXPOSE 8086

CMD ["./init.sh"]
