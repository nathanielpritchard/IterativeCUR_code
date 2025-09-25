function [Res] = proj_residual(Res, C, U, T, R, A, S, I)
   b = sum(I>0);
   [V, ~] = qr(Res(I(1:b), :)' * randn(b, 5), "econ");
   Res = Res - Res * (V * V');
   % be sure to zero out any previously selected indices
   Res(I(1:b)) = 0;
end
