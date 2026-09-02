#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
MYSQL_HOST=mysql.daws-92s.store

  if [ $USERID -ne 0 ]; then
   echo " please run this script with sudo shipping " | tee -a $LOGS_FILE
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

dnf install maven -y
VALIDATE $? "Installing mavan"

id roboshop
    if [ $? -ne 0 ]; then
         useradd --system --home /app --shell /sbin/nologin --comment "roboshop system shipping" roboshop &>>$LOGS_FILE
        VALIDATE $? "Creating system shipping"

   else 
         echo "shipping already exits .... skipping "
   fi

    mkdir -p /app 
    VALIDATE $? "creating app folder"

    curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
    VALIDATE $? "Downlpeading code"

     cd /app 
     VALIDATE $? "Moving app directory"

     rm -rf /app/*
     VALIDATE $? "romoving data from app"

     unzip /tmp/shipping.zip
     VALIDATE $? "unzing the code"

     cd /app 
     mvn clean package 
     VALIDATE $? "installing and clean package"

     mv target/shipping-1.0.jar shipping.jar 
     VALIDATE $? "Moving and renaming"

     cp SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
     VALIDATE $? "Copying shipping service"

     systemctl daemon-reload
     VALIDATE $? "daemon reloading"

     
     dnf install mysql -y 
     VALIDATE $? "installing mysql service"

      systemctl enable shipping
     systemctl start shipping
     VALIDATE $? "Enabling and start shipping"

     mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
     mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
     mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql

     systemctl restart shipping
     VALIDATE $? "restarting shipping"