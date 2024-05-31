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


dnf install nginx -y  &>> $Logfile

validate $? "installing nginx"

systemctl enable nginx &>> $Logfile


systemctl start nginx &>> $Logfile

validate $? "starting nginx"


rm -rf /usr/share/nginx/html/* &>> $Logfile


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $Logfile


cd /usr/share/nginx/html &>> $Logfile

unzip -o /tmp/web.zip  &>> $Logfile


cp /home/centos/shell-script/web/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $Logfile

systemctl restart nginx  &>> $Logfile

validate $? "restarted nginx"

echo "completed web script at timestamp : $timestamp" &>> $Logfile

echo "completed web script at timestamp : $timestamp"