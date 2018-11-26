#!/bin/bash
source ./env

if [ -z "$1" ]
then NAME="$INSTANCENAME" 
else NAME="$1" 
fi

gcloud compute instances create $NAME \
--machine-type $MACHINETYPE \
--image-family $IMAGEFAMILY \
--image-project $IMAGEPROJECT
