#!/bin/bash

# the first set of values after the ::: represents the max number of iterations of the approximation the second represents the blocksizes 
# the user should add a command line argument for the matrix they wish to test as described in test_block.sh
parallel --link -j 3 ./test_block.sh {1} $1 {2} > OUT/blocks/status_$1_blocks_{2}_{1}.out ::: 100 200 300 400 500 10 20 30 40 50 5 10 15 20 25 1 2 3 4 5 ::: 5 5 5 5 5 50 50 50 50 50 100 100 100 100 100 500 500 500 500 500
