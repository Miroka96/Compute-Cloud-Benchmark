#!/bin/bash
source ./env

ssh -o StrictHostKeyChecking=no -i $KEYNAME.pem ec2-user@$(./get-ip.sh $1) ${@:2}
