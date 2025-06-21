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

dnf install mongodb-org -y 
VALIDATE $? "Installing mongodb server"

systemctl enable mongod 
VALIDATE $? "Enabling MongoDB"

systemctl start mongod 
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing MongoDB conf file for remote connections"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"





