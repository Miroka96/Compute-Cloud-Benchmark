#!/bin/bash
# usage: ./copy-file.sh <instance-id> <filename>
source ./env

for file in ${@:2}
do gcloud compute scp $file $1:~/
done
