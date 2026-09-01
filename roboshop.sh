#!/bin/bash
SG_ID=sg-0027bf26309cfab1a
AMI_ID=ami-0220d79f3f480ecf5
HOSTED_ZONE="Z00617561PSXR6GVLL7IW"
DOMAIN_NAME="daws-92s.store"

for instance in $@
do 
aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance},{Key=Environment,Value=Production}]" \
    --query 'Instances[0].PrivateIpAddress' \
    --output text 
    if [ $INSTANCE=="frontend" ]; then
    IP=$(
        aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[*].Instances[*].publicIpAddress" \
    --output text )
    $RECORD_NAME="$INSTANCE_ID.$DOMAIN_NAME" #.daws-92s.store
    else

        IP=$( aws ec2 describe-instances \
    --instance-ids  $INSTANCE_ID \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text )
        $RECORD_NAME="$INSTANCE.$DOMAIN_NAME" #mongodb.daws-92s.store

   fi
   echo " IP address : $IP "

   aws route53 change-resource-record-sets \
    --hosted-zone-id $HOSTED_ZONE \
    --change-batch ' 
    {
  "Comment": "Updating the A record",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORD_NAME'",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "$IP"
          }
        ]
      }
    }
  ]
}
'
done