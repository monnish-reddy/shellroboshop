#!/bin/bash
USER_ID=$(id -u)
R="\e[31m]"
G="\e[32m]"
Y="\e[33m]"
N="\e[0m]"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0|cut -d '.' -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER

if [ $USER_ID -ne 0 ]
then 
    echo -e "$R ERROR:: Plese run the script with root access $N" | tee -a $LOG_FILE
    exit 1
else
    echo -e "You are running with root access" | tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}
cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "copiying the mongodb.repo"

dnf install mogodb -y
VALIDATE $? "installing mongodb"

systemctl enable mongodb
VALIDATE $? "enable the mongodb"

systemctl start mongod 
VALIDATE $? "starting mongodb"





