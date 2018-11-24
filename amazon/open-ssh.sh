#!/bin/bash
source ./env

ssh -i $KEYNAME.pem ec2-user@$(./get-ip.sh $1) ${@:2}
