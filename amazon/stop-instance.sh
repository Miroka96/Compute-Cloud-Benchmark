#!/bin/bash

aws ec2 stop-instances --instance-ids $1
./wait-for-instance-stop.sh $1
