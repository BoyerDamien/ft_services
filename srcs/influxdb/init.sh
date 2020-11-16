#! /bin/sh

if [ ! -d /root/.influxdb/data ]
then
	influxd & influx setup -u user -p password -o 42  -b ft_services --retention=1d --force
else
	influxd
fi
