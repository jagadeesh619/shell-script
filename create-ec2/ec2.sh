#!/bin/bash

ami_id="ami-0f3c7d07486cad139"
sg_id="sg-06875d4a9e4510053"
instances_type=""
instances=("mongodb" "catalogue" "web")

for i in "${instances[@]}"
do  
    if [ $i=="mongodb" ]
    then
        instances_type="t3.micro"
    else
        instances_type="t2.micro"
    fi
    Private_ip=$(aws ec2 run-instances --image-id $ami_id --count 1 --instance-type $instances_type  --security-group-ids $sg_id     --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text) 
    echo "instance : $i : $Private_ip"

done


