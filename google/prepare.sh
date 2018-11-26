#!/bin/bash -e
source ./env

if [ -z "$1" ]
then NAME="$INSTANCENAME" 
else NAME="$1" 
fi

./open-ssh.sh $NAME 'bash -c "sudo apt update && sudo apt install -y fio gcc"'
./copy-file.sh $NAME ../benchmark/*
./stop-instance.sh $NAME
