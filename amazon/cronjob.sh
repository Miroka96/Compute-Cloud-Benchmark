#!/bin/bash -e
source ./env

./start-instance.sh $1
sleep 1
./open-ssh.sh $1 ./linpack.sh
./open-ssh.sh $1 ./memsweep.sh

./stop-instance.sh $1
