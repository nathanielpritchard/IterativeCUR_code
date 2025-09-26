% a script that can be used to generate the csvs that are
% clean_csvs/selection_methods. You must modify this script to recreate
% each dataset. Instructions for how things should be modified can be found
% in comments on lines 12-48
addpath("./index_selection")
addpath("./over_sample_res")
addpath("./matrix_generation")
addpath("./curers")
addpath("./error_methods")
addpath("./pseudoInv_update.m/")
rng(13132,"twister");
% specify the type of matrix you wish to test
mat_lab = "Low_Rank_PD";
% Specify the generation rank (this is only relevant for Low_Rank_PD)
ran = 100;
% Specify the size of the matrix, for these experiments this can be set to
% 1000
n = 1000;
% Specify the gap between rank values this will be 
% 200 for all experiments
gap = 200;
% Specify the starting rank to test this will be
% 200: For chan and wilkinson
% 150: For all other matrices
start_rank = 200;
% Specify the max rank, this will be 1000 for all matrices
max_rank = 1000;
constants = Test_Constants;
constants.epsilon = 1e-14;
% specify the block size this will be 50 for every experiment except
% wilkinson
constants.block_size = 50;
% specify the oversampling parameter, this is not discussed in the paper
% and should be set to zero to replicate results
constants.over_sample = 0.0;
ntrials = 5;

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% uncomment the correct matrix
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% if Low_Rank_PD or bayer08 use this like
A = mat_gen(mat_lab, ran, n);
% If circul, forsythe, grcar, lehmer use this line
%A = gallery("lehmer", n);
% If chan use this line
%A = eye(n) + -1 * tril(true(size(eye(n))), -1);
% If wilkinson use this line
%A = wilkinson(n);

% to ensure the qr selection works properly the matrix must be dense
A = full(A);
iterations = start_rank:gap:max_rank;
% generate all of the storage vectors
nranks = length(iterations);
lu_acc = zeros(nranks * ntrials, 1);
qr_acc = zeros(nranks * ntrials, 1);
os_acc = zeros(nranks * ntrials, 1);
svds_acc = zeros(nranks * ntrials, 1);
svd_acc = zeros(nranks * ntrials, 1);
ranks = zeros(nranks * ntrials, 1);
lu_acc_med = zeros(nranks, 1);
qr_acc_med = zeros(nranks, 1);
os_acc_med = zeros(nranks, 1);
svds_acc_med = zeros(nranks, 1);
svd_acc_med = zeros(nranks, 1);
ranks_med = zeros(nranks, 1);
counter = 1;

St = svd(A, "vector");
for mi = iterations
    constants.maxit = mi;
    nA = norm(double(A), 'fro');
    constants.rel_epsilon = constants.epsilon * nA;
    if constants.maxit == 0
        i_maxit = 0;
    else
        i_maxit = constants.maxit;
    end

    fprintf("LUPP \n")
    k = (counter - 1) * ntrials + 1;
    for i = 1:ntrials
        tic(); [err, C, W, T, R] =  IterativeCUR(A, constants.block_size, constants.rel_epsilon, constants.over_sample, @zero_residual, @idx_LU, @idx_LU, @idx_LU, @approx_error, i_maxit); toc();
        lu_acc(k) = BigNormCUR(A,C,W,T,R) / nA;
        k = k + 1;
    end

    fprintf("QR \n")
    k = (counter - 1) * ntrials + 1;
    for i = 1:ntrials
        tic(); [err, C, W, T, R] =  IterativeCUR(A, constants.block_size, constants.rel_epsilon, constants.over_sample, @zero_residual, @idx_QR, @idx_QR, @idx_QR, @approx_error, i_maxit); toc();
        qr_acc(k) = BigNormCUR(A,C,W,T,R) / nA;
        k = k + 1;
    end

    fprintf("OS \n")
    k = (counter - 1) * ntrials + 1;
    for i = 1:ntrials
        tic(); [err, C, W, T, R] =  IterativeCUR(A, constants.block_size, constants.rel_epsilon, constants.over_sample, @zero_residual, @idx_OS, @idx_OS, @idx_QR, @approx_error, i_maxit); toc();
        os_acc(k) = BigNormCUR(A,C,W,T,R) / nA;
        k = k + 1;
    end
    
    k = (counter - 1) * ntrials + 1;
    tic(); [U, S, V, err_s] = svdsketch(A, max(constants.epsilon, 2e-8), 'BlockSize', constants.block_size, 'MaxIterations', constants.maxit, 'MaxSubspaceDimension', constants.maxit * constants.block_size);toc();
    se = norm(A - U * S * V' ,'fro') / nA;
    svds_acc(k:k+ntrials-1) = se;
    % Compute the true svd error
    svd_acc(k:k+ntrials-1) = sqrt(sum(St(constants.maxit * constants.block_size+1:end).^2)) / nA;
    ranks(k:k+ntrials-1) = constants.maxit * constants.block_size;
    ranks_med(counter) = constants.maxit * constants.block_size;
    svd_acc_med(counter) = sqrt(sum(St(constants.maxit * constants.block_size+1:end).^2)) / nA;
    svds_acc_med(counter) = se;
    lu_acc_med(counter) = median(lu_acc(k:k+ntrials-1));
    qr_acc_med(counter) = median(qr_acc(k:k+ntrials-1));
    os_acc_med(counter) = median(os_acc(k:k+ntrials-1));
    counter = counter + 1;
end

ft = table(ranks, lu_acc, qr_acc, os_acc, svd_acc, svds_acc, 'VariableNames',{'rank', 'lupp', 'qr', 'os', 'svd', 'svds'});
mt = table(ranks_med, lu_acc_med, qr_acc_med, os_acc_med, svd_acc_med, svds_acc_med, 'VariableNames', {'rank', 'lupp', 'qr', 'os', 'svd', 'svds'});
ft_name = append("./clean_csvs/selection_methods/", mat_lab,"_",num2str(size(A,1)),"_",num2str(constants.block_size), ".csv");
mt_name = append("./clean_csvs/selection_methods/", mat_lab,"_",num2str(size(A,1)),"_",num2str(constants.block_size),"_med.csv");
writetable(ft, ft_name);
writetable(mt, mt_name);