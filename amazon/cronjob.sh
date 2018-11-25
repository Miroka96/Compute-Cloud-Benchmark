#!/bin/bash -e
source ./env

OUT=output.csv

touch $OUT

./start-instance.sh $1
sleep 1
CPU=./open-ssh.sh $1 ./linpack.sh
RAM=./open-ssh.sh $1 ./memsweep.sh
IOS=./open-ssh.sh $1 ./measure-disk-sequential.sh
IOR=./open-ssh.sh $1 ./measure-disk-random.sh

echo "$CPU;$RAM;IOS;$IOR" >> $OUT

./stop-instance.sh $1
