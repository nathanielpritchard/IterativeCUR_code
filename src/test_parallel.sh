#!/bin/bash
nohup ./test.sh 2 $1 > OUT/same_rank/status_$1_2.out &
nohup ./test.sh 4 $1 > OUT/same_rank/status_$1_4.out &
nohup ./test.sh 8 $1 > OUT/same_rank/status_$1_8.out &
nohup ./test.sh 12 $1 > OUT/same_rank/status_$1_12.out &
nohup ./test.sh 16 $1 > OUT/same_rank/status_$1_16.out &
