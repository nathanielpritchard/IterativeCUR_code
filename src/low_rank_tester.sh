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

while getopts m:n:b:r:s:o:e:i: flag
do
	case "${flag}" in
		m) M=${OPTARG};;
		n) N=${OPTARG};;
		b) B=${OPTARG};;
		r) R=${OPTARG};;
		s) S=${OPTARG};;
		o) O=${OPTARG};;
		e) E=${OPTARG};;
        i) I=${OPTARG};;
	esac
done

matlab -nodisplay -batch "mat_lab = {'$M'}; n = $N; ran = $R; n_samples = $S; C = Test_Constants; C.block_size = $B; C.over_sample = $O; C.epsilon = $E; C.maxit = $I; rigorous_test"
