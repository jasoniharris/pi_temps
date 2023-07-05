#/bin/bash!
# Triggered every 10 mins via alert_publisher service 

nursery_temperature=${NURSERY_TEMP} #Set by sensor_data_logger service
alerts_enabled="/tmp/alert.lock"
topic_arn="arn:aws:sns:eu-west-2:728887003700:nursery-temperature"

check_service_running () {
    service=$1
    echo "checking service ${service}"    
    result=`systemctl status ${service} | grep active | wc -l`
    echo "result is ${result}"    
    return ${result}
}

publish_alert () {
    message=$1
    aws sns publish --topic-arn ${topic_arn} --message ${message} --region eu-west-2 --profile pi
}

#If flag is active, DO NOT publish message to recipients
if [ -f "$alerts_enabled" ]; then
    exit
fi

if check_service_running "sensor_data_logger" -ne 1;then
    # publish_alert "sensor_data_logger is not running"
    exit
fi

if check_service_running "outside_temp_logger" -ne 1;then
    # publish_alert "outside_temp_logger is not running"
    exit
fi

#If outside of 18-25c then trigger text message
if [[ ${nursery_temperature} -le 18 || ${nursery_temperature} -ge 25 ]]; then
    echo "Temp is ${nursery_temperature}"
    # publish_alert "Nursery temperature is unfavourable: ${nursery_temperature}"
fi


