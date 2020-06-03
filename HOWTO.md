# Start the containers
Type in `docker-compose up`in the folder where docker_compose.yml lies.

The backend will start, and shortly after expose all required services on port 80.
# Good practices
This step is not mandatory, but is highly recommended as a fine-tuned user management usually avoids a lot of various problems.

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
`curl -XPOST "http://localhost:80/query?u=admin&p=admin" --data-urlencode "q=GRANT ALL ON apolline TO demo"`

![CURL](/howto_resources/gp_curl_1.png)

Now this command will work out of the box on most Linux and macOS systems. On Windows you need the `curl` tool, which you can get at this url : [CURL for Windows](https://curl.haxx.se/windows/), if you don't have CURL already installed within WSL, Git Bash or any other GNU-related environment.

### Giving administrative rights (not recommended)
If you don't want to use curl, you can use Chronograf's `InfluxDB Admin`/`Users` tab to grant `ALL` permission on the newly-created user, which will effectively give administrative rights onto the whole InfluxDB.

## Changing Grafana data source
Now that we have a new user, we might want to setup Grafana so that the default data source uses our newly-created user instead of the default administrative one.

Open http://localhost/grafana.

On the left panel, click `Configuration`/`Data sources`.
![Grafana Data Sources](/howto_resources/gp_datasource_1.png)

Click `InfluxDB - Apolline`.

At the bottom of the page, replace `admin` with the newly-created user's name. Click `Reset` and type the user's password. 

![Grafana Data Sources](/howto_resources/gp_datasource_2.png)

Finally, click `Save & Test` to ensure the database is working as intended.

![Grafana Data Sources](/howto_resources/gp_datasource_3.png)

# Sending data to InfluxDB
## Configure Apolline-Alpha app
Open the Apolline-Alpha Android app on your phone. Tap `Configuration` and set `Address`, `User` and `Pass` to your backend's settings.

![App configuration](/howto_resources/ca_conf_1.png)

## Connect to sensor
Return to the app's main menu. Tap `Connexion` and select your sensor in the list.

![App configuration](/howto_resources/ca_conf_2.png)

Tap `Capteur`. Wait for a while, and the app should start getting data from the sensor and pushing them to InfluxDB.

![App configuration](/howto_resources/ca_conf_3.png)

# Visualizing data in Grafana
The InfluxDB database now gets data from the phone, but we need to visualize them. We will use Grafa to that end.
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