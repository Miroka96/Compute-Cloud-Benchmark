#!/bin/bash -e

# https://www.binarylane.com.au/support/solutions/articles/1000055889-how-to-benchmark-disk-i-o

# random read
READ=$(fio --thread --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --runtime=7 --readwrite=randread --minimal --size=4G | cut -d ";" -f 8)

# random write
WRITE=$(fio --thread --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --runtime=7 --readwrite=randwrite --minimal --size=4G | cut -d ";" -f 49)

rm test

echo "$WRITE + $READ" | bc
