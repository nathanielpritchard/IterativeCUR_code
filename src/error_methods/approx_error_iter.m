function [norm_res, Res, U, T] = approx_error_iter(SA, ResL, S2, S, C, U, T, R, cidx, ridx, block_size, over_sample)
        % Inputs:
        % SA sketch of A
        % ResL - Sketched residual
        % S - sketch
        % C, R - most recent included
        % U, T - most recent not included
        % cidx, ridx - most recent included
        % rows are oversampled - last block_size(1+over_sample) is relevant

        % Outputs:
        % norm_res - norm of residual
        % Res - residual matrix
        % U,T is qr for the next update.

        row_size = round((1+over_sample)*block_size);
        col_size = block_size;
        Is = ridx(end-row_size+1:end);
        Js = cidx(end-col_size+1:end);

        if size(C,2) == col_size
            tempMat = R(end-row_size+1:end,:);
        else
            tempMat = R(end-row_size+1:end,:) - (((C(Is,1:end-col_size))/T)*U')*R(1:end-row_size,:);
        end
        [QUU,RUU] = qr(tempMat(:,Js),0);
        Res = ResL - ResL(:,Js)*(RUU\(QUU'*tempMat));
        % Use a right sketching matrix here to speed up f-norm computation
        norm_res = norm(Res * S2, 'fro');
        [U,T] = qr(C(ridx,:));
end
