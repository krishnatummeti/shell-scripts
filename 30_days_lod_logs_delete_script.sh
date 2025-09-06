#!/bin/bash

# Directory where log files are stored
LOG_DIR="/path/to/logs"

# Delete log files older than 30 days
find "$LOG_DIR" -type f -name "*.log" -mtime +30 -exec rm -f {} \;

echo "Deleted log files older than 30 days from $LOG_DIR"
