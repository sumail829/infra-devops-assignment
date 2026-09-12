#!/bin/bash

LOG="/var/log/infra_health.log"

echo " $(date)" >> $LOG

echo "CPU usage is:"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')%" >> $LOG


echo "RAM: $(free | awk '/Mem:/ {printf "%.1f", $3/$2*100}')%" >> $LOG




DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
echo "Disk: $DISK%" >> $LOG

if [ $DISK -gt 85 ]; then
    echo "WARNING: Disk usage above 85%" >> $LOG
fi



if systemctl is-active --quiet docker; then
    echo "Docker: Running" >> $LOG
else
    echo "WARNING: Docker is not running" >> $LOG
fi

if docker ps --format '{{.Names}}' | grep -q flask_app; then
    echo "App: Running" >> $LOG
else
    echo "WARNING: App is not running" >> $LOG
fi

echo "" >> $LOG
