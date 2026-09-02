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

    curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
    VALIDATE $? "Downlpeading code"

     cd /app 
     VALIDATE $? "Moving app directory"

     rm -rf /app/*
     VALIDATE $? "romoving data from app"

     unzip /tmp/user.zip
     VALIDATE $? "unzing the code"

     npm install 
     VALIDATE $? "downloeading depencies" 

     cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
     VALIDATE $? "coping user.service to user"

     systemctl daemon-reload
     VALIDATE $? "demon reloading"

     systemctl enable user 
     VALIDATE $? "Enabling user"
    
     systemctl start user
     VALIDATE $? "starting user"
     