#!/bin/bash 
EXECUTABLE="linpack"
if [ ! -e $EXECUTABLE ] ; then
	#echo "Compiling linpack.c"
	cc -O -o linpack linpack.c -lm
fi


if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
	result=$(./linpack.exe | tail -1 | sed "s/[[:blank:]]\+/ /g" | cut -d " " -f 7)
else
	./$EXECUTABLE
fi
