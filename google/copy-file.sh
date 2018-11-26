#!/bin/bash
# usage: ./copy-file.sh <instance-id> <filename>
source ./env

for file in ${@:2}
do scp -o StrictHostKeyChecking=no -i $KEYNAME.pem $file ec2-user@$(./get-ip.sh $1):.
done