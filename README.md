# apolline-backend-ng
Docker image for deployment of Apolline software stack.

# How to use
## Running the image

The image can be run using :

```
docker-compose up
```

# Web server routing

By default, the routing exposed by NGINX is the following :

* localhost/grafana/ : Grafana
* localhost/admin/ : Chronograf
* localhost/ : InfluxDB

# Default configuration
## InfluxDB

InfluxDB has an "apolline" database pre-created.

## Grafana

Grafana has default logins "admin/admin" (change them!), and has InfluxDB preconfigured as a data source.

## Chronograf

Chronograf has default logins "admin/admin" (change them!), and has InfluxDB preconfigured as a data source, allowing fast configuration of InfluxDB through it.

# Configuring Grafana and Chronograf

As the InfluxDB is running standalone in its own container, Grafana and Chronograf won't be able to access it on http://localhost:80/. 

Use instead `http://influxdb:8086/`.
