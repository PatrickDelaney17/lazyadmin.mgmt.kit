#!/bin/bash

# Variables
LOGFILE="/var/log/network-check.log"
INTERFACE="wlan0"  # Network interface to restart (adjust as needed)
FINAL_ACTION="${FINAL_ACTION:-reboot}"  # Default action after 4 failures ("reboot" or "shutdown")
CHECK_INTERVAL="${CHECK_INTERVAL:-300}"  # Default to 5 minutes if not set
MAX_LOG_SIZE=$((1024 * 1024 * 10))  # 10MB max logfile size

# Ensure the logfile exists and has appropriate permissions
if [ ! -f "$LOGFILE" ]; then
    echo "$(date): [INFO] Log file does not exist. Creating $LOGFILE with appropriate permissions."
    sudo touch "$LOGFILE"
    sudo chmod 666 "$LOGFILE"
fi


# Skip chmod since permissions are already set
echo "$(date): [INFO] Log file is ready for writing." >> "$LOGFILE"

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"

    # Clear logfile if it exceeds max size
    logfile_size=$(du -b "$LOGFILE" | cut -f1)
    if [[ $logfile_size -ge $MAX_LOG_SIZE ]]; then
        echo "$(date): [INFO] Logfile exceeded 10MB. Clearing." > "$LOGFILE"
    fi

    echo "$(date): [$level] $message" >> "$LOGFILE"
}

# Function to restart the network interface
restart_network() {
    log_message "INFO" "Restarting network interface: $INTERFACE."
    sudo ifconfig $INTERFACE down
    sleep 5
    sudo ifconfig $INTERFACE up
}

# Main network check logic
attempt_count=0

while [[ $attempt_count -lt 2 ]]; do
    if ping -c 1 -W 2 8.8.8.8 > /dev/null; then
        log_message "INFO" "Network is connected. Stopping checks."
        exit 0
    else
        log_message "ERROR" "Network check failed (Attempt $((attempt_count + 1)))."
        attempt_count=$((attempt_count + 1))
        sleep 30
    fi
done

# Restart network service if 2 attempts fail
restart_count=0

while [[ $restart_count -lt 4 ]]; do
    restart_network
    sleep 30

    if ping -c 1 -W 2 8.8.8.8 > /dev/null; then
        log_message "INFO" "Network reconnected after restarting interface."
        exit 0
    fi

    log_message "ERROR" "Network restart attempt $((restart_count + 1)) failed."
    restart_count=$((restart_count + 1))
done

# Final action if all restart attempts fail
log_message "ERROR" "Network still unreachable after 4 restart attempts. Performing final action: $FINAL_ACTION."
if [[ "$FINAL_ACTION" == "shutdown" ]]; then
    sudo shutdown -h now
else
    sudo reboot
fi