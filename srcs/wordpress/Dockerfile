#! /bin/sh

FROM alpine

USER root

RUN apk update && && apk upgrade
RUN apk add curl --no-cache 
RUN mkdir -p /var/www/
RUN curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz && mv ./wordpress ./var/www
ADD ./srcs/wp-config.php /var/www/wordpress/wp-config.php
RUN rm latest.tar.gz

EXPOSE 80
