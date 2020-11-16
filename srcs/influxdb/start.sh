#! /bin/sh

curl -X POST 'http://localhost:8086/query' --data-urlencode "q=CREATE DATABASE telegraf"
curl -X POST 'http://localhost:8086/query' --data-urlencode "q=CREATE USER user WITH PASSWORD 'password'"
