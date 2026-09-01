#!/bin/bash
AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-0027bf26309cfab1a"
INS_TYPE="t3.micro"



for instance in $@

do
aws ec2 run-instances \
    --image-id AMI_ID \
    --instance-type INS_TYPE \
    --security-group-ids SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyInstanceName}]' \
    --query 'Instances[0].PrivateIpAddress' \
    --output text



done