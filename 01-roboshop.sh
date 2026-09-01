#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-0027bf26309cfab1a"
INS_TYPE="t3.micro"
ZONE_ID="Z00617561PSXR6GVLL7IW"
DOMAIN_NAME="daws-92s.store"

for instance in $@
do
aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INS_TYPE \
    --security-group-ids $SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=mongodb}]' \
    --query 'Instances[0].PrivateIpAddress' \
    --output text

    if [ $INSTANCE_ID=="frontend" ]; then
        
        IP=$(aws ec2 describe-instances\
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[].Instances[].PublicIpAddress'\
        --output text)
        RECORD_NAME="$DOMAIN_NAME" #recordname of frontend

        else 
        IP=$(aws ec2 describe-instances\
        --instance-ids $INSTANCER_ID \
        --query 'Reservations[].Instances[].privateIpAddress'\
        --output text)
        RECORD_NAME="$INSTANCE.$DOMAIN_NAME"
        fi 


        aws route53 change-resource-record-sets  
        --hosted -zone-id $ZONE_ID 
        --change-batch '{
  "Comment": "Updating the IP address for my domain",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORD_NAME'",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "'$IP'"
          }
              ]
      }
    }
             ]
                        }
 '


done
echo " record updated for $INSTANCE_ID "