#!/bin/bash -e
source ./env

if [ -z "$1" ]
then NAME="$INSTANCENAME" 
else NAME="$1" 
fi

if [ ! -z "$2" ]; then
	COMMANDS="--"
fi

gcloud compute ssh $NAME $COMMANDS ${@:2}
