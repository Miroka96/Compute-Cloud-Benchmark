#!/bin/bash
# automate with: 0 * * * *	cd /root/Compute-Cloud-Benchmark/amazon/ && ./cronjob.sh i-0eb40592c3e1df399 2>&1 > /root/cronerror.log

source ./env

echo started

CLOUD=ec2

echo "Trying to start instance $1"
time ./start-instance.sh $1

echo instance started

UP=1
while [ $UP -gt 0 ]
do echo "is it up?"
	time ./open-ssh.sh $1 echo "instance now up" > /dev/null
	UP=$?
	sleep 1
done

echo instance hopefully up
CPU=$(time ./open-ssh.sh $1 ./linpack.sh)
echo "$(date +%s),$CPU" >> $CLOUD-cpu.csv
echo "benchmarked CPU"

RAM=$(time ./open-ssh.sh $1 ./memsweep.sh)
echo "$(date +%s),$RAM" >> $CLOUD-mem.csv
echo "benchmarked RAM"

IOS=$(time ./open-ssh.sh $1 ./measure-disk-sequential.sh)
echo "$(date +%s),$IOS" >> $CLOUD-disk-sequential.csv
echo "benchmarked IO seq"

IOR=$(time ./open-ssh.sh $1 ./measure-disk-random.sh)
echo "$(date +%s),$IOR" >> $CLOUD-disk-random.csv
echo "benchmarked IO rand"

echo "benchmarking done"

time ./stop-instance.sh $1

echo "instance stopped"
