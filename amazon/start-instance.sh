#!/bin/bash

aws ec2 start-instances --instance-ids $1
./wait-for-instance.sh $1
