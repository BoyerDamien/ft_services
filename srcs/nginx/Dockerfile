#! /bin/sh

FROM alpine

USER root

RUN apk update && apk upgrade
RUN apk add nginx openrc openssl openssh --no-cache

EXPOSE 80 443 22

ENTRYPOINT  nginx -g 'pid /tmp/nginx.pid; daemon off;'
