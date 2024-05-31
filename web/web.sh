#!/bin/bash
timestamp=$(date +%F-%H-%M-%S)

Logfile="/tmp/$0-$timestamp.log"

validate() {
    if [ $1 -eq 0 ]
    then
        echo -e "\e[32m $2 successfully done "
    else
        echo -e "\e[31m $2 Error"
        exit 1
    fi
}
ID=$(id -u)

if [ $ID -eq 0 ]
then
    echo "Your are root user"
else
    echo "Run the script with root user"
    exit 1
fi

echo "Executing web script at timestamp : $timestamp" &>> $Logfile


dnf install nginx -y

systemctl enable nginx


systemctl start nginx


rm -rf /usr/share/nginx/html/*


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip


cd /usr/share/nginx/html

unzip /tmp/web.zip


cp roboshop.conf /etc/nginx/default.d/roboshop.conf 

systemctl restart nginx 