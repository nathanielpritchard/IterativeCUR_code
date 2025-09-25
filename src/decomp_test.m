function [Results] = decomp_test(A, nsamples, func, constants, nA, svd)
    % This is a function that for a specific test function and matrix
    % takes applies the low rank approximation method.
    % !!! You need to write wrapper functions so that each function takes
    % the input of epsilon. SVD will need to have 3 outputs, while CURs
    % will have 4. `nA` represents the norm of A, if do not want relative
    % norm set this to be 1.
    sample_nums = (1:nsamples)';
    times = zeros(nsamples,1);
    n_cols = zeros(nsamples,1);
    n_rows = zeros(nsamples,1);
    left_accuracy = zeros(nsamples,1);
    right_accuracy = zeros(nsamples,1);
    overall_accuracy = zeros(nsamples,1);
    for i = 1:nsamples
        % SVD and CUR functions will return different outputs so
        % must make differentiation
        if svd
            tic
                [U, S, V] = func(A, constants);
            times(i) = toc;
            left_accuracy(i) = BigNormLeft(A,U) / nA;
            right_accuracy(i) = BigNormRight(A, V) / nA;
            overall_accuracy(i) = BigNormSVD(A, S) / nA;
            n_rows(i) = size(V, 2);
            n_cols(i) = size(U, 2);
        else
            tic
                [C, U, T, R] = func(A, constants);
            times(i) = toc;
            % Use qr here instead of pinv
            [Ql, ~] = qr(C, 'econ');
            left_accuracy(i) = BigNormLeft(A, Ql) / nA;
            % for rows must use qr on the transpose of the matrix!
            [Qr, ~] = qr(R', 'econ');
            right_accuracy(i) = BigNormRight(A, Qr) / nA;
            overall_accuracy(i) = BigNormCUR(A, C, U, T, R) / nA;
            n_rows(i) = size(R, 1);
            n_cols(i) = size(C, 2);
        end

    end
    var_names = {'sample', 'time', 'n_cols', 'n_rows', 'left_accuracy', 'right_accuracy', 'overall_accuracy'};
    Results = table(sample_nums,times, ...
        n_cols, n_rows, left_accuracy,  ...
        right_accuracy, overall_accuracy, 'VariableNames', var_names);
end
