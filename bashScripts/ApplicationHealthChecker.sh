#!/bin/bash

# Application Health Checker for Wisecow
APP_URL="https://wisecow.local/"
LOG_FILE="../scriptLogs/application_health.log"
CHECK_INTERVAL=10   # seconds

echo "===== Application Health Check Started: $(date) =====" | tee -a $LOG_FILE
echo "Monitoring: $APP_URL" | tee -a $LOG_FILE
echo "======================================================" | tee -a $LOG_FILE

while true; do
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)
    RESPONSE_TIME=$(curl -o /dev/null -s -w '%{time_total}\n' $APP_URL)
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "[$TIMESTAMP] ✅ Application is UP | Status: $STATUS_CODE | Response Time: ${RESPONSE_TIME}s" | tee -a $LOG_FILE
    else
        echo "[$TIMESTAMP] ❌ Application is DOWN | Status: $STATUS_CODE | Response Time: ${RESPONSE_TIME}s" | tee -a $LOG_FILE
        echo "[ALERT] Wisecow app might be down! Investigate immediately." | tee -a $LOG_FILE
    fi

    sleep $CHECK_INTERVAL
done
