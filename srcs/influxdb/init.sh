#! /bin/sh

influxd & jobs

if [ ! -f /root/.influxdbv2/configs ]
then
	sleep 10 && influx setup -u $DB_USER\
		-p $DB_PASSWORD\
		-o $INFLUX_ORGANIZATION\
		-b $INFLUX_BUCKET\
		-t $INFLUX_TOKEN\
		--retention=1d --force
	influx telegrafs create --name $INFLUX_BUCKET --description $INFLUX_BUCKET --file telegraf.conf
fi

telegraf --config telegraf.conf
