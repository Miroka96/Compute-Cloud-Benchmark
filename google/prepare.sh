#!/bin/bash -e

./copy-file.sh $1 ../benchmark/*
./stop-instance.sh $1
