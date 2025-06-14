#!/bin/bash


> /home/labex/project/1results.txt

cat /home/labex/project/1-test.txt | awk 'NR>1 {print $7}' > fs1.txt

cat /home/labex/project/2-test.txt | awk 'NR>1 {print $7}' > fs2.txt

comm -23 <(sort /home/labex/project/fs1.txt) <(sort /home/labex/project/fs2.txt) > /home/labex/project/results.txt


# Get unique mount points from 1-test.txt that aren't in 2-test.txt
unique_mounts=$(comm -23 <(awk 'NR>1 {print $7}' 1-test.txt | sort) <(awk 'NR>1 {print $7}' 2-test.txt | sort))

# For each unique mount point, find and print its full line from 1-test.txt
for mount in $unique_mounts; do
    grep -F "$mount" 1-test.txt > /home/labex/project/1results.txt
done



#!/bin/bash

# Clear results file
> /home/labex/project/1results.txt

# Extract mount points (skip headers)
awk 'NR>1 {print $7}' /home/labex/project/1-test.txt > /home/labex/project/fs1.txt
awk 'NR>1 {print $7}' /home/labex/project/2-test.txt > /home/labex/project/fs2.txt

# Find unique mount points in 1-test.txt (not in 2-test.txt)
comm -23 <(sort /home/labex/project/fs1.txt) <(sort /home/labex/project/fs2.txt) > /home/labex/project/results.txt

# Check if results are empty
if [ ! -s /home/labex/project/results.txt ]; then
    echo "All mount points are available"
else
    # Process results with for loop
    for mount_point in $(cat /home/labex/project/results.txt); do
        grep -F "$mount_point" /home/labex/project/1-test.txt >> /home/labex/project/1results.txt
    done
    echo "Missing mount points detected please take action accordingly. Details below:"
    # Show results
    cat /home/labex/project/1results.txt
fi

