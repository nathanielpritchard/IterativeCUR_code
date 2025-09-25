function [Res] = zero_residual(Res, C, U, T, R, A, S, I)
    Res(I(I > 0), :) = 0;
end
