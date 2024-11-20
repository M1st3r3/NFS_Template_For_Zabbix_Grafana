#!/bin/bash

# Get current timestamp and 5 minutes ago timestamp in seconds
CURRENT_TIME=$(date +%s)
FIVE_MIN_AGO=$((CURRENT_TIME - 300))  # 300 seconds = 5 minutes

# Get errors count for the last 5 minutes using the ISO 8601 timestamp format
nfs_error_count=$(grep -i "nfs" /var/log/syslog | grep -iE "permission denied|access denied|error" | while read line; do
    # Extract and convert ISO 8601 timestamp to epoch
    timestamp=$(echo "$line" | awk '{print $1}' | sed 's/T/ /' | cut -d'.' -f1)
    log_time=$(date -d "$timestamp" +%s 2>/dev/null)
    
    if [ ! -z "$log_time" ] && [ $log_time -ge $FIVE_MIN_AGO ] && [ $log_time -le $CURRENT_TIME ]; then
        echo $line
    fi
done | wc -l)

echo $nfs_error_count