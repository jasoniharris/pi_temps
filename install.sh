#!/bin/bash

sudo cp inside/*.service /etc/systemd/system/
sudo cp outside/*.service /etc/systemd/system/

sudo systemctl daemon-reload

systemctl restart sensor_data_logger
systemctl restart outside_temp_logger


