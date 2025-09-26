#!/bin/bash
# M can be one of
# "Hilbert", "Low_Rank_PD", "CSphd", "igbt3", "bayer08", "YaleB", "RandSVD", "Cauchy", "Hankel"
M=Hilbert
N=100;
B=10;
R=10;
S=20;
O=0;
E=1e-6;

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

matlab -nodisplay -batch "mat_lab = {'$M'}; n = $N; ran = $R; n_samples = $S; C = Test_Constants; C.block_size = $B; C.over_sample = $O; C.epsilon = $E; C.maxit = $I; rigorous_test_block"
