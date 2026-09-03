#!/bin/bash


USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD

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
 
 dnf module disable nginx -y
 dnf module enable nginx:1.24 -y
 dnf install nginx -y
 VALIDATE $? "diabling enabling the nginx and installing nginx"

 systemctl enable nginx 
 systemctl start nginx 
 VALIDATE $? "Enabling and starting the nginx"

 rm -rf /usr/share/nginx/html/* 
 VALIDATE $? "removing user from nginx"

 curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
 VALIDATE $? "downloeading the code"

 cd /usr/share/nginx/html 
 unzip /tmp/frontend.zip
VALIDATE $? "unziping the code"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf

systemctl restart nginx 
VALIDATE $? "restarting nginx"

