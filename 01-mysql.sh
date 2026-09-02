#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.daws-92s.store"

  if [ $USERID -ne 0 ]; then
   echo " please run this script with sudo user " | tee -a $LOGS_FILE
     exit 1
  fi 
    mkdir -p $LOGS_FOLDER
VALIDATE(){
    if [ $1 -ne 0 ]; then
    echo " $2 .... failure " | tee -a $LOGS_FILE
    exit 1
    else 
    echo " $2 .... success " | tee -a $LOGS_FILE
    fi
}   

dnf install mysql-server -y
VALIDATE $? "installing mysql"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? "enabling and diabling"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set the root password"
