#!/bin/bash
# M can be one of
# "Hilbert", "Low_Rank_PD", "CSphd", "igbt3", "bayer08", "YaleB", "RandSVD", "Cauchy", "Hankel", "Low_Rank"
# "bayer01", "venkat01", "ct20stif", "bcircuit" "TSOPF" "mark3" "c-67" "c-69" "g7jac200"
# "Haar", "randLOW", "randcorr"
# N is number of rows only relevant for "Cauchy", "Hankel", "Haar", "randcorr", "Hilbert",
# "Low_Rank", "Low_Rank_PD", and "randLow" matrices
# B is block size
# R is rank of the generated matrix only applies to "Low_Rank", "randLOW", and "Low_Rank_PD"
# S is number of trials performed
# O is oversample percent of size (as a decimal) (to replicate should be zero for all experiments)
# E is stopping threshold (look at tables for specific values for tests)
# I is the maxit can either be zero to replicate the experiments in section 4.1 
# or nonzero to run for rank/block_size iterations
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
