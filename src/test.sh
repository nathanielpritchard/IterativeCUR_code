#!/bin/bash
# M can be one of
# "Hilbert", "Low_Rank_PD", "CSphd", "igbt3", "bayer08", "YaleB", "RandSVD", "Cauchy", "Hankel", "Low_Rank"
# "bayer01", "venkat01", "ct20stif", "bcircuit" "TSOPF" "mark3" "c-67" "c-69" "g7jac200"
# "Haar", "randLOW", "randcorr"
# N is number of rows
# B is block size
# R is rank
# S is number of samples performed
# O is oversample percent of size (as a decimal) 
# E is stopping threshold
# I is the maxit can either be zero or nonzero if nonzero runs for rank/blocksize iterations
M=$2;
N=30000;
B=50;
R=5000;
S=5;
O=0.0;
E=3e-7;
I=$1;

echo "$M $N $B $E $O $I"

./low_rank_tester.sh -m $M -n $N -b $B -r $R -s $S -o $O -e $E -i $I
