import time
import sys
import datetime
import requests
from influxdb import InfluxDBClient
import json


with open('outside_config.json') as config_file:
    data = json.load(config_file)

measurement = data['measurement']
location = data['location']
host = data['host']
port = data['port']
user = data['user']
password = data['password']
dbname = data['dbname']
interval = data['interval']
appid = data['appid']

# Create the InfluxDB client object
client = InfluxDBClient(host, port, user, password, dbname)

params = {"lat": "52.840056", "lon": "-2.471194", "units": "metric", "appid": appid}
baseurl = "https://api.openweathermap.org/data/2.5/weather"
content_type = str('text/plain; version=0.0.4; charset=utf-8')

def get_outside_weather():
    response = requests.get(baseurl, params=params)
    temp = response.json()['main']['temp']
    humidity = response.json()['main']['humidity']

    return [temp, humidity]

while True:
    try:
        outside_temp = get_outside_weather()
        iso = time.ctime()
        print("[%s] Outside Temp: %s, Outside Humidity: %s" % (iso, outside_temp[0], outside_temp[1]))

        data = [
        {
          "measurement": measurement,
              "tags": {
                  "location": location,
              },
              "fields": {
                  "temperature" : outside_temp[0],
                  "humidity" : outside_temp[1]
              }
          }
        ]
        # Send the JSON data to InfluxDB
        client.write_points(data)

    except RuntimeError as error:
        # print(error.args[0])
        time.sleep(10.0)
        continue
    except Exception as error:
        raise error

    time.sleep(interval)
