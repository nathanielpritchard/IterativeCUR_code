function [errors, C, U, T, R] = IterativeCUR(A, block_size, threshold, over_sample_percent, over_sample_residual, over_sample_method, col_selection, row_selection, approxmation_error, max_it)
    % INPUTS:
    % A, the matrix being approximated
    % block_size, the number of columns rows and cols to update approx
    % threshold, the desired quality of solution in froebinius norm
    % over_sample_percent, the percent of blocksize for the over_sampling parameter
    % over_sample_residual, the function that computes a residual for oversampling
    % over_sample_method, the function to perform the over sampling
    % col_selection, the function to select the columns
    % row_selection the function to select the rows
    % 
    % OUTPUTS:
    % errors, the list of approximated errors for each iteration
    % C, the columns in the approximation
    % U, the Q matrix in the pseudo inverse of cross approximation
    % T, the R matrix in the pseudo inverse of the cross approximation
    % R, the rows in the approximation
    [rows, cols] = size(A);
    over_sample_size = floor(over_sample_percent * block_size);
    % If user inputs non zero max_it use it otherwise set it to be rows/blocksize
    naive_maxit = floor(min(rows, cols) / (3*(block_size + over_sample_size)));
    if max_it == 0
        maxit = naive_maxit;
    else
        maxit = max_it;
    end

    errors = zeros(maxit, 1);
    S = randn(ceil(1.1 * block_size), rows) ./ sqrt(ceil(1.1 * block_size));
    % Generate a second matrix to assist in calculating frobenius norm
    S2 = randn(cols, 10) ./ sqrt(10);
    SA = S * A;
    ResL = SA;
    % Preallocate the index arrays
    I = zeros((block_size + over_sample_size) * maxit, 1);
    J = zeros(block_size * maxit, 1);
    C = A;
    U = A;
    T = A;
    R = A;
    start_idx_row = 1;
    start_idx_col = 1;
    for i = 1:maxit
        % return the r matrix corresponding to res
        [J, start_idx_col] = col_selection(ResL, block_size, J, start_idx_col);
        cidx = J(1:i * block_size);
        % note the most recent columns for Right residual
        recent_cols = J((i-1) * block_size + 1:i * block_size);
        if i > 1
            % Compute the right residual, note that all unselected cols
            % zero
            % break up computation to see if oversampling is necessary
            Ap = C * (T \ (U' * R(:, recent_cols)));
            ResR = A(:, recent_cols) - Ap;
        else
            ResR = A(:, recent_cols);
        end
        old_start = start_idx_row;
        [I, start_idx_row] = row_selection(ResR', block_size, I, start_idx_row);
        if over_sample_size > 0 
            [ResR] = over_sample_residual(ResR, C, U, T, R, A, S, I);
            [I, start_idx_row] = over_sample_method(ResR', over_sample_size, I, start_idx_row);
        end
        C = A(:, cidx);
        % assuming that if a value is non-zero in I it should be a row
        % index
        ridx = I(I>0);
        R = A(ridx, :);
        new_row_len = start_idx_row - old_start;
        new_col_len = length(recent_cols);
        % Compute the pseudoinverse term
        [errors(i), ResL, U, T] = approxmation_error(SA,ResL, S2, S, C, U, T, R, cidx, ridx, block_size, over_sample_size, new_col_len, new_row_len);
        % If the number of iterations is not prespecified than you can exit
        % early
        if errors(i) < threshold && maxit == naive_maxit
            errors = errors(1:i);
            break
        end
    end

end
