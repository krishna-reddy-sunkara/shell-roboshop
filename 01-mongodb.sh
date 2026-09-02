#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

  if [ $USERID -ne 0 ]; then
   echo " please run this script with sudo user " | tee -a $LOGS_FILE
     exit 1
  fi 
    mkdir -p $LOGS_FOLDER
VALIDATE(){
    if [ $? -ne 0 ]; then
    echo " $2 .... failure " | tee -a $LOGS_FILE
    exit 1
    else 
    echo " $2 .... success " | tee -a $LOGS_FILE
    fi
}   
    mkdir -p $LOGS_FOLDER

    cp mongo.repo /etc/yum.repos.d/mongo.repo
    VALIDATE $? "coping mongo.repo "

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "installing mongodb "

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "enabling mongodb "

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connections"
 
systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "restarting mongodb"