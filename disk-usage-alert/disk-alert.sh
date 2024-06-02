#!/bin/bash

disk_usage=$(df -hT | grep -vE 'tmp|File') 
disk_limit=1
message=""

while IFS= read -r line
do
    disk_per=$( echo $line | awk '{print $6}' | cut -d % -f1)
    disk_filesys=$(echo $line | awk '{print $1}')
    if [ $disk_per -gt $disk_limit ]
    then
        message+="High Disk usage :  $disk_filesys : $disk_per \n"
    fi
done <<< $disk_usage

echo -e " Hi Team \n Please check $message" | mail -s " \e[31m High Disk Usage \e[0m " mummadijagadeesh143@gmail.com
        
