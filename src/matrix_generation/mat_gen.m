function [A] = mat_gen(mat_lab, ran, n)
    rng(3, "twister");
    if mat_lab == "Hilbert"
	rng(12123);
        A = hilb(n);
    elseif mat_lab == "Low_Rank"
	rng(12123);
        A = randn(n, ran) * randn(ran, n);
    elseif mat_lab == "Low_Rank_PD"
	rng(12123);
        A = randn(n, ran) * randn(ran, n) + diag((1-exp(-log(n)/log(5))).^(1:n));
    elseif mat_lab == "kahan"
	    A = gallery("kahan", n);
    elseif mat_lab == "CSphd"
        Mat = load("matrix_generation/sparse_matrices/CSphd.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "igbt3"
        Mat = load("matrix_generation/sparse_matrices/igbt3.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "bayer08"
        Mat = load("matrix_generation/sparse_matrices/bayer08.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "bayer01"
        Mat = load("matrix_generation/sparse_matrices/bayer01.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "bcircuit"
        Mat = load("matrix_generation/sparse_matrices/bcircuit.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "ct20stif"
        Mat = load("matrix_generation/sparse_matrices/ct20stif.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "venkat01"
        Mat = load("matrix_generation/sparse_matrices/venkat01.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "YaleB"
        Mat = load("matrix_generation/sparse_matrices/YaleB_10NN.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "mark3"
        Mat = load("matrix_generation/sparse_matrices/mark3jac140.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "TSOPF"
        Mat = load("matrix_generation/sparse_matrices/TSOPF_FS_b39_c19.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "c-67"
        Mat = load("matrix_generation/sparse_matrices/c-67.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "c-69"
        Mat = load("matrix_generation/sparse_matrices/c-69.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "g7jac200"
        Mat = load("matrix_generation/sparse_matrices/g7jac200.mat");
        A = Mat.Problem.A;
    elseif mat_lab == "RandSVD"
	rng(12123);
        A = gallery("randsvd", n, 1e50,3, n, n, 1);
    elseif mat_lab == "Cauchy"
        A = gallery("cauchy", n);
    elseif mat_lab == "Hankel"
        A = hankel(rand(n));
    elseif mat_lab == "Haar"
        A = generate_haar(n) + diag((1-exp(-log(n)/log(5))).^(1:n));
    elseif mat_lab == "GCD"
        A = gallery("gcdmat", n);
    elseif mat_lab == "randcorr"
	rng(12123);
	x = log(2).^((1:n)./(log(n)));
	x = x / sum(x) * n;
	A = gallery("randcorr", x);
	A = A.^2;
    elseif mat_lab == "randLOW"
	rng(12123);
        G1 = randn(n, ran);
	G2 = randn(n, ran);
	Q1 = qr(G1);
	Q2 = qr(G2);
	A = Q1 * diag(1 ./ (1:ran)) * Q2';
    end
end
