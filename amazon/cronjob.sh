#!/bin/bash -e
source ./env

CLOUD=ec2

./start-instance.sh $1

sleep 1
CPU=$(./open-ssh.sh $1 ./linpack.sh)
echo "$(date +%s),$CPU" >> $CLOUD-cpu.csv

RAM=$(./open-ssh.sh $1 ./memsweep.sh)
echo "$(date +%s),$RAM" >> $CLOUD-mem.csv

IOS=$(./open-ssh.sh $1 ./measure-disk-sequential.sh)
echo "$(date +%s),$IOS" >> $CLOUD-disk-sequential.csv

IOR=$(./open-ssh.sh $1 ./measure-disk-random.sh)
echo "$(date +%s),$IOR" >> $CLOUD-disk-random.csv

./stop-instance.sh $1
