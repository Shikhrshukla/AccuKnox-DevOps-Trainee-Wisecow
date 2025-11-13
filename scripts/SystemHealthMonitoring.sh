#!/bin/bash

# System Health Monitoring Script
LOG_FILE="../scriptLogs/system_health.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

echo "===== System Health Check: $(date) =====" | tee -a $LOG_FILE

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d'.' -f1)
# Memory Usage
MEM_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
# Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

# Display metrics
echo "CPU Usage: ${CPU_USAGE}%" | tee -a $LOG_FILE
echo "Memory Usage: ${MEM_USAGE}%" | tee -a $LOG_FILE
echo "Disk Usage: ${DISK_USAGE}%" | tee -a $LOG_FILE
echo "" >> $LOG_FILE

# Alert function
alert() {
    echo "[ALERT] $1" | tee -a $LOG_FILE
}

# Check thresholds
[ $CPU_USAGE -gt $CPU_THRESHOLD ] && alert "High CPU usage: ${CPU_USAGE}%"
[ $MEM_USAGE -gt $MEM_THRESHOLD ] && alert "High Memory usage: ${MEM_USAGE}%"
[ $DISK_USAGE -gt $DISK_THRESHOLD ] && alert "Low Disk space: ${DISK_USAGE}% used"

# Top 5 CPU-consuming processes
echo "Top 5 CPU-consuming processes:" | tee -a $LOG_FILE
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 | tee -a $LOG_FILE

echo "=========================================" | tee -a $LOG_FILE
echo "" >> $LOG_FILE
