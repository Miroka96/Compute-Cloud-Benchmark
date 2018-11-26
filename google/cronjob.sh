#!/bin/bash -e
# automate with: 0 * * * *	cd /root/Compute-Cloud-Benchmark/amazon/ && ./cronjob.sh i-0eb40592c3e1df399 2>&1 > /root/cronerror.log

source ./env

if [ -z "$1" ]
then NAME="$INSTANCENAME" 
else NAME="$1" 
fi

env

echo started

CLOUD=google

./start-instance.sh $NAME

echo instance started
sleep 20

echo instance hopefully up
CPU=$(./open-ssh.sh $NAME ./linpack.sh)
echo "$(date +%s),$CPU" >> $CLOUD-cpu.csv
echo "benchmarked CPU"

RAM=$(./open-ssh.sh $NAME ./memsweep.sh)
echo "$(date +%s),$RAM" >> $CLOUD-mem.csv
echo "benchmarked RAM"

IOS=$(./open-ssh.sh $NAME ./measure-disk-sequential.sh)
echo "$(date +%s),$IOS" >> $CLOUD-disk-sequential.csv
echo "benchmarked IO seq"

IOR=$(./open-ssh.sh $NAME ./measure-disk-random.sh)
echo "$(date +%s),$IOR" >> $CLOUD-disk-random.csv
echo "benchmarked IO rand"

echo "benchmarking done"

./stop-instance.sh $NAME

echo "instance stopped"
