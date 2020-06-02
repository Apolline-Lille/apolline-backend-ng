#!/bin/bash

# Grafana/InfluxDB/NGINX run script
# Start nginx
nginx

# Start Influx in background
influxd &

chronograf --host 0.0.0.0 --port 8888 --basepath /admin -b /var/lib/chronograf/chronograf-v1.db &

# Start Grafana
grafana-server --homepath /usr/share/grafana --config /etc/grafana/grafana.ini

