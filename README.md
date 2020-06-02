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

# Configuring Grafana and Chronograf

As the InfluxDB is running standalone in its own container, Grafana and Chronograf won't be able to access it on http://localhost:80/. 

Use instead `http://influxdb:8086/`.
