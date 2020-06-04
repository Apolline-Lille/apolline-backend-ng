# Start the containers
Type in `docker-compose up`in the folder where docker_compose.yml lies.

The backend will start, and shortly after expose all required services on port 80.

# User management
This step is not mandatory, and should be followed ONLY if you want to create different user than the ones bundled with the backend.

The backend already provides a `grafana` user with read rights for Grafana, and a `apollineapp` user with write rights for the Android application.

## Creating a new user
Go to http://localhost/admin, which will open the Chronograf tool.

On the left panel, select `InfluxDB Admin`. 

![InfluxDB Admin](/howto_resources/gp_useradd_1.png)

Then go to the `Users` tab, click `Create user` and give it a user name and password. Click the green tick.

![InfluxDB Admin](/howto_resources/gp_useradd_2.png)

## Giving the new user rights on the default Database
Currently, Chronograf does not allow setting user rights on InfluxDB databases.

This is a known bug, as stated on the InfluxDB website :

![InfluxDB Admin](/howto_resources/gp_useradd_3.png)

### Giving rights through CURL (recommended)
To correctly grant access rights on the database, use this workaround command in a command line interface to grant access rights on the `apolline` database to the user `demo` (change `demo` with the user name you just created).
`curl -XPOST "http://localhost:80/query?u=admin&p=admin" --data-urlencode "q=GRANT WRITE ON apolline TO demo"`

![CURL](/howto_resources/gp_curl_1.png)

Now this command will work out of the box on most Linux and macOS systems. On Windows you need the `curl` tool, which you can get at this url : [CURL for Windows](https://curl.haxx.se/windows/), if you don't have CURL already installed within WSL, Git Bash or any other GNU-related environment.

### Giving administrative rights (not recommended)
If you don't want to use curl, you can use Chronograf's `InfluxDB Admin`/`Users` tab to grant `ALL` permission on the newly-created user, which will effectively give administrative rights onto the whole InfluxDB.

# Sending data to InfluxDB
## Through Apolline-Alpha app
### Configure Apolline-Alpha app
Open the Apolline-Alpha Android app on your phone. 

#### If you changed user configuration in step 1
Tap `Configuration` and set `Address`, `User` and `Pass` to your backend's settings.

#### If you did not change user configuration in step 1
Tap `Configuration` and set `Address` to your backend's IP address (http://XXX.XXX.XXX.XXX:80/).

![App configuration](/howto_resources/ca_conf_1.png)

### Connect to sensor
Return to the app's main menu. Tap `Connexion` and select your sensor in the list.

![App configuration](/howto_resources/ca_conf_2.png)

Tap `Capteur`. Wait for a while, and the app should start getting data from the sensor and pushing them to InfluxDB.

![App configuration](/howto_resources/ca_conf_3.png)

## Through CURL

### General format

You can send CURL requests on http://localhost:80/ to write data to the InfluxDB database.

A CURL request is built as following :

`curl -i -XPOST "http://localhost:80/write?db=<db>&u=<user>&p=<pass>" --data-binary "<measurement>,<tagKey1>=<tagValue>,<tagKey2>=<tagValue>,... <field>=<value>,<field2>=<value>,... <timestamp>"`

Where :

* `<db>` is the database,
* `<user>`, `<pass>` are the credentials,
* `<measurement>` is the measurement name,
* `<tagKey1>=<tagValue>,<tagKey2>=<tagValue>,...` are a list of key-value pairs for tag fields,
* `<field>=<value>,<field2>=<value>,...` are a list of field-value pairs for standard fields,
* `<timestamp>` is the timestamp of the value, formatted as a Long value

### Example

`curl -i -XPOST "http://localhost:80/write?db=apolline&u=apollineapp&p=apollineapp" --data-binary 'demo_measurement,tag1=hello,tag2=world value=0.42 1434055562000000000'`

This request writes in the `apolline` database, with user `apollineapp` and password `apollineapp`.

It writes into the measurement `demo_measurement` a new value with :
* two tags, `tag1` and `tag2` having values `hello` and `world` respectively,
* one field, `value`, having a value of 0.42,
* a timestamp of `1434055562000000000`, corresponding to Thursday 11 June 2015 20:46:02 (see https://www.epochconverter.com/ for timestamp to date conversion).

### Seeing the data

We can use the InfluxDB client by connecting it to http://localhost:80 (download it from here : https://portal.influxdata.com/downloads/) :

`influx --host localhost --port 80`

We can then see the value we just pushed onto the database :

```
> use apolline;
Using database apolline
> show measurements;
name: measurements
name
----
demo_measurement
> select * from demo_measurement;
name: demo_measurement
time                tag1  tag2  value
----                ----  ----  -----
1434055562000000000 hello world 0.42
> show tag keys from demo_measurement;
name: demo_measurement
tagKey
------
tag1
tag2
>
```

# Visualizing data in Grafana
The InfluxDB database now gets data from the phone, but we need to visualize them. We will use Grafana to that end.
## Creating a dashboard
Open Grafana at http://localhost/grafana.

Click `Dashboards`/`Manage`.

![Grafana Dashboard](/howto_resources/vd_dashboard_1.png)

Click `New dashboard`.

![Grafana Dashboard](/howto_resources/vd_dashboard_2.png)

On the top right toolbar, click `Dashboard settings`.

![Grafana Dashboard](/howto_resources/vd_dashboard_3.png)

Give a name to your dashboard, then click, `Save dashboard`.

![Grafana Dashboard](/howto_resources/vd_dashboard_4.png)

Back to the previous screen, click `Add panel` on the top right toolbar.

![Grafana Dashboard](/howto_resources/vd_dashboard_5.png)

Then click `Add new panel`.

![Grafana Dashboard](/howto_resources/vd_dashboard_6.png)

On the right panel, give a name to your panel. Here, we use Blue Sensors for this tutorial, and thus will name our panel `Particules`.

![Grafana Dashboard](/howto_resources/vd_dashboard_7.png)

At the bottom panel, we will enter the queries we want to run on the database. Click `Toggle text edit mode`.

![Grafana Dashboard](/howto_resources/vd_dashboard_8.png)

Enter the query. Here, we will use this query : `SELECT mean("value") FROM "pm.01.value" WHERE $timeFilter GROUP BY time($__interval) fill(null)`

Then click the `+ Query` button to add two more queries, and repeat process for the `pm.2.5.value` and `pm.10.value` measurements.

![Grafana Dashboard](/howto_resources/vd_dashboard_10.png)

On the top right toolbar, click `Save` and `Apply`.

![Grafana Dashboard](/howto_resources/vd_dashboard_11.png)

Back to our dashboard, setup the time range to something around 5 minutes.

![Grafana Dashboard](/howto_resources/vd_dashboard_12.png)

Enable auto-refresh of dashboard.

![Grafana Dashboard](/howto_resources/vd_dashboard_13.png)

You should see your data!

![Grafana Dashboard](/howto_resources/vd_dashboard_14.png)
