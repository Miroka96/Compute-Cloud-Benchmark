#!/bin/bash

aws ec2 wait instance-running --instance-ids $1
