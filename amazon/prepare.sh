#!/bin/bash -e

./open-ssh.sh $1 sudo yum -y install gcc fio
./copy-file.sh $1 ../benchmark/*
./stop-instance.sh $1
