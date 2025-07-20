#!/bin/bash
###############################################################################
# Script Name : compare_mount_points.sh
# Description : Compares two filesystem reports and identifies missing mount
#               points in the second report. Outputs full details for each.
# Author      : Krishna Tummeti
# Website     : https://techbasehub.com
# Date        : 20-Jul-2025
# Usage       : Run this script manually or via cron
###############################################################################

# Exit on any error
set -e

# FILE1 = Old known-good mount point list (taken previously)
# FILE2 = Current system mount point output
df -Th > /home/labex/project/mount_point_new.txt

# Input files
FILE1="/home/labex/project/disk_old_20-06-2025.txt"
FILE2="/home/labex/project/mount_point_new.txt"

# Output files
BASE_DIR="/home/labex/project"
TMP1="$BASE_DIR/file_system_old.txt"
TMP2="$BASE_DIR/file_system_new.txt"
RESULTS="$BASE_DIR/results.txt"
FULL_RESULTS="$BASE_DIR/missing_mount_details.txt"

# Clear previous outputs
> "$RESULTS"
> "$FULL_RESULTS"

# Extract mount points (column 7), skip headers
awk 'NR > 1 {print $7}' "$FILE1" > "$TMP1"
awk 'NR > 1 {print $7}' "$FILE2" > "$TMP2"

# Compare and find mount points only in FILE1 (missing in FILE2)
comm -23 <(sort "$TMP1") <(sort "$TMP2") > "$RESULTS"

# Check if anything is missing
if [ ! -s "$RESULTS" ]; then
    echo "All mount points from '$FILE1' are present in '$FILE2'."
else
    echo "Missing mount points detected! Details below:"
    
    # Use FOR loop to process and extract full lines
    for mount_point in $(cat "$RESULTS"); do
        grep -F "$mount_point" "$FILE1" >> "$FULL_RESULTS"
    done

    cat "$FULL_RESULTS"
    echo
    echo "Full details saved in: $FULL_RESULTS"
fi
