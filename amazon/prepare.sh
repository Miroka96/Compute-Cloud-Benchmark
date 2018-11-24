#!/bin/bash -e

./open-ssh.sh $1 sudo yum install gcc
./copy-file.sh $1 ../benchmark/*
./stop-instance.sh $1
