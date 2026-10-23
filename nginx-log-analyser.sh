#!/bin/bash

# Nginx Log Analyser

# DESCRIPTION: This script automates the process of parsing Nginx access log files
#               to extract critical system metrics. It isolates traffic patterns by tracking 
#                the top 5 source IPs, request locations, HTTP response statuses, and user 
#                  agents to help sysadmins identify bot noise, user trends, or potential attacks.
# USAGE:
#              ./log_analyzer.sh /path/to/nginx/access.log
# AUTHOR:      OPSBYNYIKO

set -o pipefail

LOGFILE="$1"

# Handle Empty Strings, Missing Files & Unreadable Files
if [ -z "$LOGFILE" ] || [ ! -f "$LOGFILE" ] || [ ! -r "$LOGFILE" ]; then
    echo "Usage: $0 /path/to/nginx/access.log" >&2
    exit 1
fi


echo -e "\n TOP 5 MOST FREQUENT IP ADDRESSES"
awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

echo -e "\n TOP 5 MOST REQUESTED PATHS"
awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

echo -e "\n TOP 5 RESPONSE STATUS CODES"
awk '{print $9}' "$LOGFILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

echo -e "\n TOP 5 USER AGENTS"
awk -F'"' '{print $6}' "$LOGFILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'
