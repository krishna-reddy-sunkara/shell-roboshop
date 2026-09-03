
#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"


if [ $USERID -ne 0 ]; then
    echo  " Please run this script with root user access " | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ...  FAILURE  | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ...  SUCCESS " | tee -a $LOGS_FILE
    fi
}

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Install MySQL server"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld  
VALIDATE $? "Enable and start mysql"

# get the password from user
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"