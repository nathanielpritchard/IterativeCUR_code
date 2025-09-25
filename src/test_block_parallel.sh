#!/bin/bash
#nohup ./test_block.sh 100 $1 5 > OUT/blocks/status_$1_blocks_5_200.out &
#nohup ./test_block.sh 200 $1 5 > OUT/blocks/status_$1_blocks_5_200.out &
#nohup ./test_block.sh 300 $1 5 > OUT/blocks/status_$1_blocks_5_300.out &
#nohup ./test_block.sh 400 $1 5 > OUT/blocks/status_$1_blocks_5_400.out &
#nohup ./test_block.sh 500 $1 5 > OUT/blocks/status_$1_blocks_5_400.out &
#nohup ./test_block.sh 10 $1 50 > OUT/blocks/status_$1_blocks_50_20.out &
#nohup ./test_block.sh 20 $1 50 > OUT/blocks/status_$1_blocks_50_20.out &
#nohup ./test_block.sh 30 $1 50 > OUT/blocks/status_$1_blocks_50_30.out &
#nohup ./test_block.sh 40 $1 50 > OUT/blocks/status_$1_blocks_50_40.out &
#nohup ./test_block.sh 50 $1 50 > OUT/blocks/status_$1_blocks_50_40.out &
#nohup ./test_block.sh 5 $1 100 > OUT/blocks/status_$1_blocks_100_10.out &
#nohup ./test_block.sh 10 $1 100 > OUT/blocks/status_$1_blocks_100_10.out &
#nohup ./test_block.sh 15 $1 100 > OUT/blocks/status_$1_blocks_100_15.out &
#nohup ./test_block.sh 20 $1 100 > OUT/blocks/status_$1_blocks_100_20.out &
#nohup ./test_block.sh 25 $1 100 > OUT/blocks/status_$1_blocks_100_20.out &
#nohup ./test_block.sh 1 $1 500 > OUT/blocks/status_$1_blocks_500_2.out &
#nohup ./test_block.sh 2 $1 500 > OUT/blocks/status_$1_blocks_500_2.out &
#nohup ./test_block.sh 3 $1 500 > OUT/blocks/status_$1_blocks_500_3.out &
#nohup ./test_block.sh 4 $1 500 > OUT/blocks/status_$1_blocks_500_4.out & 
#nohup ./test_block.sh 5 $1 500 > OUT/blocks/status_$1_blocks_500_4.out & 

#parallel --link -j 3 ./test_block.sh {1} $1 {2} > OUT/blocks/status_$1_blocks_{2}_{1}.out ::: 100 200 300 400 500 10 20 30 40 50 5 10 15 20 25 1 2 3 4 5 ::: 5 5 5 5 5 50 50 50 50 50 100 100 100 100 100 500 500 500 500 500
parallel --link -j 3 ./test_block.sh {1} $1 {2} > OUT/blocks/status_$1_blocks_{2}_{1}.out ::: 500 1000 1500 2000 2500 ::: 1 1 1 1 1
