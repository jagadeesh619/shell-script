#!/bin/bash
timestamp=$(date +%F-%H-%M-%S)

Logfile="/tmp/$0-$timestamp.log"

validate() {
    if [ $1 -eq 0 ]
    then
        echo -e "\e[32m $2 successfully done "
    else
        echo -e "\e[31m $2 Error "
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

echo "Executing catalogue script at timestamp : $timestamp" &>> $Logfile

echo "Executing catalogue script"

dnf module disable nodejs -y &>> $Logfile

validate $? "disable nodejs"  


dnf module enable nodejs:18 -y  &>> $Logfile

validate $? "enable nodejs 18 "  

dnf install nodejs -y  &>> $Logfile

validate $? "installing nodejs"


id roboshop #if roboshop user does not exist, then it is failure

if [ $? -ne 0 ]
then
    useradd roboshop &>> $Logfile
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi


mkdir -p /app  &>> $Logfile

validate $? "created app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $Logfile


validate $? "downloaded catalogue zip file"

cd /app &>> $Logfile

unzip -o /tmp/catalogue.zip  &>> $Logfile

npm install  &>> $Logfile

cp /home/centos/shell-script/catalogue/catalogue.service /etc/systemd/system/catalogue.service   &>> $Logfile

validate $? " copying catalogue service"

systemctl daemon-reload  &>> $Logfile

systemctl start catalogue &>> $Logfile

validate $? "catalogue started"


cp /home/centos/shell-script/catalogue/mongo.repo /etc/yum.repos.d/mongo.repo  &>> $Logfile

dnf install mongodb-org-shell -y   &>> $Logfile

mongo --host mongodb.infome.website </app/schema/catalogue.js  &>> $Logfile

validate $? "dataloaded into mongodb"

echo "executing Mongodb script completed at timestamp : $timestamp "   &>> $Logfile

echo -e "\e[32m catalogue installation completed"  