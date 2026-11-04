#!/usr/bin/env bash

while true
do
    echo "$(date '+%F %T') worker heartbeat" >> /var/log/worker.log
    sleep 5
done