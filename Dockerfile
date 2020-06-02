# Debian base
FROM debian

WORKDIR /root/apolline

# Copy files from host to container
COPY imageFiles/run.sh .

# Commands
RUN chmod a+x run.sh
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-get install -y software-properties-common wget gnupg2
RUN wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
RUN add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
RUN apt-get update
RUN apt-get install -y nginx grafana
RUN wget https://dl.influxdata.com/chronograf/releases/chronograf_1.8.4_amd64.deb
RUN dpkg -i chronograf_1.8.4_amd64.deb
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.0_amd64.deb
RUN dpkg -i influxdb_1.8.0_amd64.deb

# Expose port 80 for nginx
EXPOSE 3000
EXPOSE 80
EXPOSE 8086
EXPOSE 8888

# Copy configuration files
COPY imageFiles/conf/default /etc/nginx/sites-available/default
COPY imageFiles/conf/grafana.ini /etc/grafana/grafana.ini

# Commands on start
CMD [ "/root/apolline/run.sh" ]

# Copy other stuff such as Influx/Grafana configuration files
