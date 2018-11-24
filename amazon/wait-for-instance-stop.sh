#!/bin/bash

aws ec2 wait instance-stopped --instance-ids $1
