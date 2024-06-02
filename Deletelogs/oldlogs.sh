#!/bin/bash


cd /tmp/roboshop-logs

if [ $? -ne 0 ]
then
    echo "Directory is not available Please check "
    exit 1
fi

files=$(find /tmp/roboshop-logs -type f -mtime +14 -name "*.log")


while IFS= read -r file
do
    echo "deleting the log file : $file"
    rm -rf $file
done <<<  $files
