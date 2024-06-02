#!/bin/bash

ami_id="ami-0f3c7d07486cad139"
sg_id="sg-06875d4a9e4510053"
instances_type=""
instances=("mongodb" "catalogue" "web")
domain="infome.website"
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

    aws route53 change-resource-record-sets \
  --hosted-zone-id Z01480582Y8DVJZNPON84 \
  --change-batch '
  {
    "Comment": "Roboshop creating a record set"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$domain'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$Private_ip'"
        }]
      }
    }]
  } '

done


