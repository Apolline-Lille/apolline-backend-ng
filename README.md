# apolline-backend-ng
Docker image for deployment of Apolline software stack.

# How to use
## Building the image

Build the image using :

```
docker build --tag apollinedocker:1.0 .
```

## Preparing volumes

The image requires three volumes to store persistently the InfluxDB, Grafana and Chronograf data.

Build them using :

```
docker volume create grafana-storage
docker volume create influxdb-storage
docker volume create chronograf-storage
```

## Running the image

The image can be run using :

```
docker run -p 8888:8888 -p 3000:3000 -p 80:80 --mount source=influxdb-storage,target=/var/lib/influxdb/ --mount source=grafana-storage,target=/var/lib/grafana --mount source=chronograf-storage,target=/var/lib/chronograf -it apollinedocker:1.0 /root/apolline/run.sh
```

A `start.sh` script is provided as a shortcut.

# Web server routing

By default, the routing exposed by NGINX is the following :

* localhost/grafana/ : Grafana
* localhost/admin/ : Chronograf
* localhost/ : InfluxDB
