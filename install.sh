#!/bin/bash

sudo cp inside/*.service /etc/systemd/system/
sudo cp outside/*.service /etc/systemd/system/

aws s3 cp s3://harris-pi-temps/outside_config.json outside/ --profile pi
aws s3 cp s3://harris-pi-temps/inside_config.json inside/ --profile pi

sudo systemctl daemon-reload

systemctl restart sensor_data_logger
systemctl restart outside_temp_logger


