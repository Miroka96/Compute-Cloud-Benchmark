#!/bin/bash

aws ec2 describe-instances --instance-ids $1 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
