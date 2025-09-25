function [Q,R] = updateQR(Q,R, Rows, Cols)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [ro_rows,ro_cols] = size(Rows);
    % pad the matrix here to handle allocation issues
    Q = [Q; zeros(ro_rows,ro_cols)];
    % Here we take the full of the Rows to eliminate any sparsity issues
    o = full(Rows);
    [Q,R] = row_update(Q,R,o);
    [Q,R] = col_updating_qr(Q,R,Cols);
end