function [C, U, T, R] = cur(A, rows, cols, sketch, column_selection, row_selection)
    % By setting sketch == 0 then you will not sketch
    J = zeros(1, cols);
    I = zeros(1, rows);
    if sketch > 0 
        n = size(A, 1);
        S = randn(rows, n);
        SA = S * A;
    else
        SA = A;
    end
    [J, ~] = column_selection((SA), cols, J, 1);
    C = A(:, J);
    [I, ~] = row_selection((C'), rows, I, 1);
    R = A(I, :);
    [U,T] = qr((C(I, :)), "econ");
end
