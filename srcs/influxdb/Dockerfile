#  /bin/sh

FROM alpine
VOLUME [ "/sys/fs/cgroup/" ]
ADD ./init.sh ./init.sh

RUN apk update && apk upgrade
RUN apk add --no-cache openrc curl wget gnupg
RUN openrc && touch /run/openrc/softlevel

RUN  curl -s https://repos.influxdata.com/influxdb2.key | gpg --import -
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb-2.0.1_linux_amd64.tar.gz
RUN tar xvzf influxdb-2.0.1_linux_amd64.tar.gz
RUN cp ./influxdb-2.0.1_linux_amd64/influx /usr/local/bin/
RUN cp ./influxdb-2.0.1_linux_amd64/influxd /usr/local/bin/

EXPOSE 8086

CMD ["./init.sh"]
