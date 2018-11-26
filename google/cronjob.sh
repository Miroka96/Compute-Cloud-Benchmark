#!/bin/bash
# automate with: 0 * * * *	cd /root/Compute-Cloud-Benchmark/google/ && ./cronjob.sh 2>&1 > /root/cronerror.log

source ./env

if [ -z "$1" ]
then NAME="$INSTANCENAME" 
else NAME="$1" 
fi

CLOUD=google

echo "Trying to start instance $NAME"
./start-instance.sh
STARTED=$?

while [ $STARTED -gt 0 ]
do echo "Start failed, trying $NEXT"
	rm env && ln -s $NEXT env
	source ./env
	echo "Starting new instance $NAME"
	./run-instance.sh
	echo "Preparing instance $NAME"
	./prepare.sh
	echo "Trying to start instance $NAME"
	./start-instance.sh
	STARTED=$?
done


echo instance started

UP=1
while [ $UP -gt 0 ]
do echo "is it up?"
	time ./open-ssh.sh $NAME echo "instance now up" > /dev/null
	UP=$?
	sleep 1
done

echo instance hopefully up
CPU=$(time ./open-ssh.sh $NAME ./linpack.sh)
echo "$(date +%s),$CPU" >> $CLOUD-cpu.csv
echo "benchmarked CPU"

RAM=$(time ./open-ssh.sh $NAME ./memsweep.sh)
echo "$(date +%s),$RAM" >> $CLOUD-mem.csv
echo "benchmarked RAM"

IOS=$(time ./open-ssh.sh $NAME ./measure-disk-sequential.sh)
echo "$(date +%s),$IOS" >> $CLOUD-disk-sequential.csv
echo "benchmarked IO seq"

IOR=$(time ./open-ssh.sh $NAME ./measure-disk-random.sh)
echo "$(date +%s),$IOR" >> $CLOUD-disk-random.csv
echo "benchmarked IO rand"

echo "benchmarking done"

time ./stop-instance.sh $NAME

echo "instance stopped"
