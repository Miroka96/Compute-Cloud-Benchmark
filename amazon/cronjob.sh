#!/bin/sh
source ./env

./start-instance.sh $1

./open-ssh.sh $1 echo hi

./stop-instance.sh $1
