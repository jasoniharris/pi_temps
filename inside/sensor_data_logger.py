import time
import sys
import datetime
import board
import adafruit_dht
from influxdb import InfluxDBClient
import requests
import json

with open('inside_config.json') as config_file:
    data = json.load(config_file)

measurement = data['measurement']
location = data['location']
host = data['host']
port = data['port']
user = data['user']
password = data['password']
dbname = data['dbname']
interval = data['interval']

client = InfluxDBClient(host, port, user, password, dbname)

dhtDevice = adafruit_dht.DHT22(board.D4, use_pulseio=False)

while True:
    try:
        temperature_c = dhtDevice.temperature
        temperature_f = temperature_c * (9 / 5) + 32
        humidity = dhtDevice.humidity
        iso = time.ctime()
        # Print for debugging, uncomment the below line
        print("[%s] Temp: %s, Humidity: %s" % (iso, temperature_c, humidity))

        data = [
        {
          "measurement": measurement,
              "tags": {
                  "location": location,
              },
              "fields": {
                  "temperature" : temperature_c,
                  "humidity": humidity,
              }
          }
        ]

        # Send the JSON data to InfluxDB
        client.write_points(data)

    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        # print(error.args[0])
        time.sleep(10.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error

    time.sleep(interval)