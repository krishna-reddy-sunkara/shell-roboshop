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
    if [ $1 -ne 0 ]; then
    echo " $2 .... failure " | tee -a $LOGS_FILE
    exit 1
    else 
    echo " $2 .... success " | tee -a $LOGS_FILE
    fi
}   
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "disabling nodejs"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling nodejs"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "installing nodejs"

    id roboshop
    if [ $? -ne 0 ]; then
         useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Creating system user"

   else 
         echo "user already exits .... skipping "
   fi

    mkdir -p /app 
    VALIDATE $? "creating app folder"

    curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
    VALIDATE $? "Downlpeading code"

     cd /app 
     VALIDATE $? "Moving app directory"

     unzip /tmp/catalogue.zip
     VALIDATE $? "unzing the code"

     npm install 
     VALIDATE $? "downloeading depencies" 

     cp catalogue.service /etc/systemd/system/catalogue.service
     VALIDATE $? "coping catalogue.service to catalogue"

     systemctl daemon-reload
     VALIDATE $? "demon reloading"

     systemctl enable catalogue 
     VALIDATE $? "Enabling catalogue"
    
    systemctl start catalogue
    VALIDATE $? "starting catalogue"
    
