#!/bin/bash

# Thresholds
CPU_THRESHOLD=10
MEM_THRESHOLD=10
DISK_THRESHOLD=10
PROCESS_THRESHOLD=20

# Log file
LOG_FILE="/var/log/system_health.log"

# Function to check CPU usage
check_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
    echo "[+] CURRENT Idle CPU Usage: $CPU_USAGE%"
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "ALERT: High CPU usage: ${CPU_USAGE}%" | tee -a $LOG_FILE
    fi
}

# Function to check memory usage
check_mem_usage() {
    MEM_USAGE=$(top -bn1 | grep "MiB Mem" | sed "s/.*, *\([0-9.]*\) total.*/\1/" | awk '{print $6/$4 * 100.0}')
    echo "[.] CURRENT Memory Usage: $MEM_USAGE%"
    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "ALERT: High Memory usage: ${MEM_USAGE}%" | tee -a $LOG_FILE
    fi
}

# Function to check disk usage
check_disk_usage() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    echo "[.] CURRENT Disk USAGE: $DISK_USAGE%"
    if (( DISK_USAGE > DISK_THRESHOLD )); then
        echo "ALERT: High Disk usage: ${DISK_USAGE}%" | tee -a $LOG_FILE
    fi
}

# Function to check running processes
check_running_processes() {
    RUNNING_PROCESSES=$(ps aux | wc -l)
    echo "Running processes: $RUNNING_PROCESSES" | tee -a $LOG_FILE
}

# Check system health
check_system_health() {
    echo "Checking system health at $(date)" | tee -a $LOG_FILE
    check_cpu_usage
    check_mem_usage
    check_disk_usage
    check_running_processes
    echo "System health check complete at $(date)" | tee -a $LOG_FILE
    echo "------------------------------------------" | tee -a $LOG_FILE
}

# Run the system health check every 60 seconds
while true; do
    check_system_health
    sleep 60
done
