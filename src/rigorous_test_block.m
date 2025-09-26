w = warning('off','all');
addpath("./index_selection")
addpath("./over_sample_res")
addpath("./matrix_generation")
addpath("./curers")
addpath("./error_methods")
addpath("./pseudoInv_update.m/")
% Define the global variables
% n = 6000;
% ran = 50;
% n_samples = 3;
% mat_lab = "Low_Rank_PD";
% C = Test_Constants;
% C.epsilon = 7e-6;
% C.block_size = 100;
% C.over_sample = 0;
% C.maxit = 10;

% Generate the matrix 
maxNumCompThreads(8);
A = mat_gen(mat_lab, ran, n);
n = size(A,1);
fprintf("Generated Matrix ")

% define wrapper functions to have similar outputs
function [U, S, V] = svdsketch_wrap(A, constants)
    % when maxit is zero set it to the default size
    if constants.maxit == 0
        maxit = ceil(min(size(A)) / constants.block_size);
	maxdim = min(size(A));
    else
        maxit = constants.maxit;
	maxdim = constants.block_size * constants.maxit; 
    end
    [U, S, V, ~] = svdsketch(A, constants.epsilon, 'BlockSize', constants.block_size, 'MaxIterations', maxit, 'MaxSubspaceDimension', maxdim);
end

function [C, U, T, R] = IterativeCUR_QR_wrap(A, constants)
    % when maxit is zero then the function runs according to threshold
    % otherwise it corresponds to the maxit parameter
    if constants.maxit == 0
        maxit = 0;
    else
        maxit = constants.maxit;
    end
    [~, C, U, T, R] = IterativeCUR(A, constants.block_size, constants.rel_epsilon, constants.over_sample, @zero_residual, @idx_QR, @idx_QR, @idx_QR, @approx_error, maxit);
end

function [C, U, T, R] = IterativeCUR_LU_wrap(A, constants)
    % when maxit is zero then the function runs according to threshold
    % otherwise it corresponds to the maxit parameter
    if constants.maxit == 0
        maxit = 0;
    else
        maxit = constants.maxit;
    end
    [~, C, U, T, R] = IterativeCUR(A, constants.block_size, constants.rel_epsilon, constants.over_sample, @zero_residual, @idx_LU, @idx_LU, @idx_LU, @approx_error, maxit);
end

function [C, U, T, R] = curQR_wrap(A, constants)
    [C, U, T, R] = cur(A, constants.n_rows, constants.n_cols, 0, @idx_QR, @idx_QR);
end

function [C, U, T, R] = curQR_sketch_wrap(A, constants)
    [C, U, T, R] = cur(A, constants.n_rows, constants.n_cols, constants.n_rows, @idx_QR, @idx_QR);
end

function [C, U, T, R] = curLU_wrap(A, constants)
    [C, U, T, R] = cur(A, constants.n_rows, constants.n_cols, 0, @idx_LU, @idx_LU);
end

function [C, U, T, R] = curLU_sketch_wrap(A, constants)
    [C, U, T, R] = cur(A, constants.n_rows, constants.n_cols, constants.n_rows, @idx_LU, @idx_LU);
end

% Intialize empty filename and dataset vectors that will be appended to when experiments run
filenames = {};
tables = {};
% Compute norm of matrix
nA = norm(A, 'fro');
C.rel_epsilon = C.epsilon * nA;

% Testing portion
%svd_data = decomp_test(A, n_samples, @svdsketch_wrap, C, nA, true);
%svd_data.("method") = repelem(["svds"], [n_samples])';
%svd_data.("threshold") = repelem([C.epsilon], [n_samples])';
%svd_data.("mat_label") = repelem([mat_lab], [n_samples])';
%svd_filename = append("csvs/svd_", mat_lab,"_",num2str(n), "_",  num2str(C.block_size),"_",num2str(C.over_sample), "_", num2str(C.maxit),".csv");
%filenames{end+1} = svd_filename;
%tables{end+1} = svd_data;
%fprintf("SVD Sketch ")

%ran = svd_data.n_cols(1);
%C.n_rows = ran;
%C.n_cols = ran;


% curqr_data = decomp_test(A, n_samples, @curQR_wrap, C, nA, false);
% curqr_data.("method") = repelem(["QRPP_cur"], [n_samples])';
% curqr_data.("threshold") = repelem([C.epsilon], [n_samples])';
% curqr_data.("mat_label") = repelem([mat_lab], [n_samples])';
% curqr_filename = append("csvs/curqr_", mat_lab,"_",num2str(n), "_",  num2str(C.block_size),"_",num2str(C.over_sample), "_",  num2str(C.maxit),".csv");
% filenames{end+1} = curqr_filename;
% tables{end+1} = curqr_data;
% fprintf("QR CUR ")
% 
% cursqr_data = decomp_test(A, n_samples, @curQR_sketch_wrap, C, nA, false);
% cursqr_data.("method") = repelem(["QRPP_sketch_cur"], [n_samples])';
% cursqr_data.("threshold") = repelem([C.epsilon], [n_samples])';
% cursqr_data.("mat_label") = repelem([mat_lab], [n_samples])';
% cursqr_filename = append("csvs/cursqr_", mat_lab,"_",num2str(n), "_",  num2str(C.block_size),"_",num2str(C.over_sample), "_", num2str(C.maxit),".csv");
% filenames{end+1} = cursqr_filename;
% tables{end+1} = cursqr_data;
% fprintf("SQR CUR ")

% curlu_data = decomp_test(A, n_samples, @curLU_wrap, C, nA, false);
% curlu_data.("method") = repelem(["LUPP_cur"], [n_samples])';
% curlu_data.("threshold") = repelem([C.epsilon], [n_samples])';
% curlu_data.("mat_label") = repelem([mat_lab], [n_samples])';
% curlu_filename = append("csvs/curlu_", mat_lab,"_",num2str(n), "_",  num2str(C.block_size),"_",num2str(C.over_sample), "_", num2str(C.maxit),".csv");
% filenames{end+1} = curlu_filename;
% tables{end+1} = curlu_data;
% fprintf("LU CUR ")

%curslu_data = decomp_test(A, n_samples, @curLU_sketch_wrap, C, nA, false);
%curslu_data.("method") = repelem(["LUPP_sketch_cur"], [n_samples])';
%curslu_data.("threshold") = repelem([C.epsilon], [n_samples])';
%curslu_data.("mat_label") = repelem([mat_lab], [n_samples])';
%curslu_filename = append("csvs/curslu_", mat_lab,"_",num2str(n), "_",  num2str(C.block_size),"_",num2str(C.over_sample),"_", num2str(C.maxit),".csv");
%filenames{end+1} = curslu_filename;
%tables{end+1} = curslu_data;
%fprintf("SLU CUR ")


%i_curqr_data = decomp_test(A, n_samples, @IterativeCUR_QR_wrap, C, nA, false);
%i_curqr_data.("method") = repelem(["QRPP_iterative_cur"], [n_samples])';
%i_curqr_data.("threshold") = repelem([C.epsilon], [n_samples])';
%i_curqr_data.("mat_label") = repelem([mat_lab], [n_samples])';
%i_curqr_filename = append("csvs/iterative_curqr_", mat_lab,"_",num2str(n), "_", num2str(C.block_size),"_",num2str(C.over_sample), "_", num2str(C.maxit),".csv");
%filenames{end+1} = i_curqr_filename;
%tables{end+1} = i_curqr_data;
%fprintf("Fast CURQR ")

i_curlu_data = decomp_test(A, n_samples, @IterativeCUR_LU_wrap, C, nA, false);
i_curlu_data.("method") = repelem(["LUPP_iterative_cur"], [n_samples])';
i_curlu_data.("threshold") = repelem([C.epsilon], [n_samples])';
i_curlu_data.("mat_label") = repelem([mat_lab], [n_samples])';
i_curlu_filename = append("csvs/iterative_curlu_", mat_lab,"_",num2str(n), "_", num2str(C.block_size),"_",num2str(C.over_sample),"_",  num2str(C.maxit),".csv");
filenames{end+1} = i_curlu_filename;
tables{end+1} = i_curlu_data;
fprintf("Fast CURLU ")

fprintf("\n")

% Save the tables that are output
n_tests = length(filenames);

for i = 1:n_tests
    writetable(tables{i}, filenames{i});
end
