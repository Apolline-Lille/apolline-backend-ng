#!/bin/bash

# Starts the previously built container with :
# - Port 80 open
# - Volumes mounted at appropriate paths
# - Detached
# - Name "Apolline"

docker run -p 80:80 --mount source=influxdb-storage,target=/var/lib/influxdb/ --mount source=grafana-storage,target=/var/lib/grafana --mount source=chronograf-storage,target=/var/lib/chronograf --name "Apolline" -d apollinedocker:1.0
