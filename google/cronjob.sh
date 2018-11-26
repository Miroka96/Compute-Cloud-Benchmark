#!/bin/bash -e
# automate with: 0 * * * *	cd /root/Compute-Cloud-Benchmark/amazon/ && ./cronjob.sh i-0eb40592c3e1df399 2>&1 > /root/cronerror.log

source ./env

env

echo started

CLOUD=ec2

./start-instance.sh $1

echo instance started
sleep 10

echo instance hopefully up
CPU=$(./open-ssh.sh $1 ./linpack.sh)
echo "$(date +%s),$CPU" >> $CLOUD-cpu.csv
echo "benchmarked CPU"

RAM=$(./open-ssh.sh $1 ./memsweep.sh)
echo "$(date +%s),$RAM" >> $CLOUD-mem.csv
echo "benchmarked RAM"

IOS=$(./open-ssh.sh $1 ./measure-disk-sequential.sh)
echo "$(date +%s),$IOS" >> $CLOUD-disk-sequential.csv
echo "benchmarked IO seq"

IOR=$(./open-ssh.sh $1 ./measure-disk-random.sh)
echo "$(date +%s),$IOR" >> $CLOUD-disk-random.csv
echo "benchmarked IO rand"

echo "benchmarking done"

./stop-instance.sh $1

echo "instance stopped"
