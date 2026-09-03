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
   cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
   VALIDATE $? "coping rabbitmq repo into rabbitmq"

   dnf install rabbitmq-server -y
   VALIDATE $? "installing rabbitmq server"

   systemctl enable rabbitmq-server
   VALIDATE $? "enabling rabbitmq"

   systemctl start rabbitmq-server
   VALIDATE $? "Starting rabbitmq"

   rabbitmqctl add_user roboshop roboshop123
   rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
   VALIDATE $? "created user to rabbitmq"
   