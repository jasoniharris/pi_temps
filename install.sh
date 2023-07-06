
 aws s3 cp s3://harris-pi-temps/outside_config.json outside/ --profile pi
 aws s3 cp s3://harris-pi-temps/inside_config.json inside/ --profile pi

# Check services exist in crontab, if not add them
service_check () {
  service=$1 
  result=`crontab -l | grep ${service} | wc -l`
  echo ${result}
  return ${result}  
}

if [ `service_check "sensor_data_logger"` -eq 0 ]; then
  # sudo echo "*/1 * * * * cd /home/pi/pi_temps/inside/ && python3 sensor_data_logger.py > /dev/null 2>&1" >> /var/spool/cron/crontabs/pi 
  echo "sensor_data_logger service not in crontab"
fi

if [ `service_check "outside_temp_logger"` -eq 0 ]; then
  # sudo echo "*/1 * * * * cd /home/pi/pi_temps/outside/ && python3 outside_temp_logger.py > /dev/null 2>&1" >> /var/spool/cron/crontabs/pi 
  echo "outside_temp_logger service not in crontab"
fi
