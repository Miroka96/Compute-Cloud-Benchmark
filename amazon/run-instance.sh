#!/bin/bash
source ./env

INSTANCEID=$(aws ec2 run-instances --image-id $IMAGEID --security-group-ids $SECURITYGROUP --count 1 --instance-type t2.nano --key-name $KEYNAME --query 'Instances[0].InstanceId' --output text)
./wait-for-instance.sh $INSTANCEID
echo $INSTANCEID
