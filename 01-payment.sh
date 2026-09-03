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

dnf install python3 gcc python3-devel -y
VALIDATE $? "installing paython "

id roboshop
if [ $? -ne o ]; then

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "creating system user"
else 
echo "user already exit ... skipping"
fi

mkdir -p /app 
VALIDATE $? "creating app folder"

curl -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zi
VALIDATE $? "Downlpeading code"

cd -p /app 
VALIDATE $? "Moving app directory"

rm -rf /app/*
VALIDATE $? "romoving data from app"

unzip /tmp/payment.zip
VALIDATE $? "unzing the code"

cd /app
VALIDATE $? "Moving to app directory"

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/payment.zip &>>$LOGS_FILE
VALIDATE $? "Uzip payment code"

cd /app 
pip3 install -r requirements.txt &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service
VALIDATE $? "Created systemctl service"
systemctl daemon-reload
systemctl enable payment &>>$LOGS_FILE
systemctl start payment
VALIDATE $? "Enabled and started payment"