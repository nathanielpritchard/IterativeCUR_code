function [norm_res, Res, U, T] = approx_error(SA,ResL, S2, S, C, U, T, R, cidx, ridx, block_size, over_sample, new_col_len, new_row_len)
        % [U, T] = qr(C(ridx, :));
        if false%istriu(T)
            [U, T] = updateQR(full(U),full(T),R((end-new_row_len+1):end,cidx(1:(end-new_col_len))),C(ridx, (end-new_col_len+1):end));
        else
            [U,T] = qr((C(ridx, :)));
        end
        sketch = SA(:, cidx);
        ort = ((sketch / T) * U');
        inv = ort * R;
        Res = SA -  inv;
        % Use a right sketching matrix here to speed up f-norm computation
        norm_res = norm(Res * S2, 'fro');
end
