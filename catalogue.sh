#!/bin/bash

USERID=$(id -u)
LOGS_FLODER="/var/log/shell-roboshop"
LOGS_FILE="LOGS_FLODER/$0.log"

  if [ $USERID -ne 0 ]; then
   echo " please run this script with sudo user " | tee -a $LOGS_FILE
     exit 1
  fi 
   
VALIDATE(){
    if [ $? -ne 0 ]; then
    echo " $2 .... failure " | tee -a $LOGS_FILE
    exit 1
    else 
    echo " $2 .... success " | tee -a $LOGS_FILE
    fi
}   

dnf module disable nodejs -y
VALIDATE $? "diabling nodejs"

dnf module enable nodejs:20 -y 
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y 
VALIDATE $? "Installing nodejs"

id roboshop &>>LOGS_FILE
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "creating system user"
else 
echo "user already exits"

mkdir -p /app 
VALIDATE $? "Creating directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "downloeading code"
