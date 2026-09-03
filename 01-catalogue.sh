# #!/bin/bash

# USERID=$(id -u)
# LOGS_FOLDER="/var/log/shell-roboshop"
# LOGS_FILE="$LOGS_FOLDER/$0.log"
# SCRIPT_DIR=$PWD
# MONGODB_HOST="mongodb.daws-92s.store"

#   if [ $USERID -ne 0 ]; then
#    echo " please run this script with sudo user " | tee -a $LOGS_FILE
#      exit 1
#   fi 
#     mkdir -p $LOGS_FOLDER
# VALIDATE(){
#     if [ $1 -ne 0 ]; then
#     echo " $2 .... failure " | tee -a $LOGS_FILE
#     exit 1
#     else 
#     echo " $2 .... success " | tee -a $LOGS_FILE
#     fi
# }   
#     dnf module disable nodejs -y &>>$LOGS_FILE
#     VALIDATE $? "disabling nodejs"

#     dnf module enable nodejs:20 -y &>>$LOGS_FILE
#     VALIDATE $? "Enabling nodejs"

#     dnf install nodejs -y &>>$LOGS_FILE
#     VALIDATE $? "installing nodejs"

#     id roboshop
#     if [ $? -ne 0 ]; then
#          useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
#         VALIDATE $? "Creating system user"

#    else 
#          echo "user already exits .... skipping "
#    fi

#     mkdir -p /app 
#     VALIDATE $? "creating app folder"

#     curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
#     VALIDATE $? "Downlpeading code"

#      cd /app 
#      VALIDATE $? "Moving app directory"

#      rm -rf /app/*
#      VALIDATE $? "romoving data from app"

#      unzip /tmp/catalogue.zip
#      VALIDATE $? "unzing the code"

#      npm install 
#      VALIDATE $? "downloeading depencies" 

#      cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
#      VALIDATE $? "coping catalogue.service to catalogue"

#      systemctl daemon-reload
#      VALIDATE $? "demon reloading"

#      systemctl enable catalogue 
#      VALIDATE $? "Enabling catalogue"
    
#      systemctl start catalogue
#      VALIDATE $? "starting catalogue" 

#      cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
#      VALIDATE $? "copying mongo.repo into catalogue"

#      dnf install mongodb-mongosh -y
#      VALIDATE $? "installing mongodb"

#     INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
#         if [ $INDEX -lt 0 ]; then
#      mongosh --host $MONGODB_HOST </app/db/master-data.js
#      VALIDATE $? "products are loading"
#      else
#      echo "products are loaded.skipping"
#      fi
#      systemctl restart catalogue
#      VALIDATE $? "Restarting catalogue"
     
 




#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws-92s.store

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "Disabling NodeJS Default version"

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "Enabling NodeJS 20"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Install NodeJS"

id roboshop &>>$LOGS_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
    VALIDATE $? "Creating system user"
else
    echo -e "Roboshop user already exist ... $Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading catalogue code"

cd /app
VALIDATE $? "Moving to app directory"

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "Uzip catalogue code"

npm install  &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable catalogue  &>>$LOGS_FILE
systemctl start catalogue
VALIDATE $? "Starting and enabling catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "Restarting catalogue"