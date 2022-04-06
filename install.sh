#!/bin/bash

sudo cp dining_room/*.service /etc/systemd/system/
sudo cp outside/*.service /etc/systemd/system/

sudo systemctl daemon-reload

systemctl restart sensor_data_logger
systemctl restart outside_temp_logger

if [ -z ${pi_temps_appid+x} ]; then echo "appid is unset"; else echo "appid is set to '${pi_temps_appid}'"; fi

