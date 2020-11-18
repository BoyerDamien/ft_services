#! /bin/sh

if [ ! -d /usr/share/grafana/public ]
then
	apk add --no-cache grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
	mv /usr/sbin/grafana-server . && mv /usr/bin/grafana-cli .
	./grafana-cli admin reset-admin-password $ADMIN_PASSWORD
fi

./grafana-server --config=/usr/share/grafana/conf/defaults.ini
