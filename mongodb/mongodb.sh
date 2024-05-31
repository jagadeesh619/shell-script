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

echo "Executing MongoDB script at timestamp : $timestamp" &>> $Logfile


validate $? "repo added"  

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $Logfile

dnf install mongodb-org -y &>> $Logfile

validate $? "installing Mongodb" 

systemctl enable mongod  &>> $Logfile

systemctl start mongod  &>> $Logfile

validate $? "started Mongodb"  

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $Logfile

validate $? "replaced IP 0.0.0.0"  

systemctl restart mongod  &>> $Logfile

validate $? "restarted Mongodb"  

echo "executing Mongodb script completed at timestamp : $timestamp "   &>> $Logfile

echo -e "\e[32m Mongodb installation completed"  