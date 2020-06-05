# apolline-backend-ng
Docker image for deployment of Apolline software stack.

# How to use
## Running the image

The image can be run using :

```
./apolline.sh up [variant]
```

Where `variant` is :
* nothing, or `default`, for the minimal image running InfluxDB, Grafana, Chronograf and the backup service
* `jupyter` to start Jupyter as well on `localhost/jupyter`.

## About Jupyter

The password required to access http://localhost/jupyter is defaulted to `jupyter`.

## Users

The following users are preconfigured :

* grafana/grafana : Grafana read-only user
* jupyter/jupyter : Jupyter read-only user
* apollineapp/apollineapp : Apolline Alpha Android app write-only user

# Setting up backups

In the `docker-compose.yml`, in the `backup` section, you will find several environment variables you have to set :

* BACKUP_DATABASE is the database you want to backup,
* BACKUP_SSH_REMOTE is the address of the remote backup server (or "no" if no remote backup),
* BACKUP_SSH_USER is the user on the remote backup server,
* BACKUP_SSH_PATH is the path to the backup folder on the remote server.

When the containers are first started, a private-public keypair is generated on the backup container. You can find them in the `backups/ssh` subfolder :

* Add the contents of `id_rsa.pub` into the backup server user's `authorized_keys` file,
* Ensure `PubkeyAuthentication` is set to `yes` in the remote server's sshd configuration,
* Ensure `rsync` is installed on the remote server.

So, when you first startup your containers, remote backup probably will fail because you haven't set the container's SSH keys into your remote server. The backups are not lost though : they remain local, and will be synced through rsync once the correct setup has been done on the server. Just make sure you set the container's SSH keys in `backups/ssh` into your remote server as soon as possible, and you should be good to go.

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
