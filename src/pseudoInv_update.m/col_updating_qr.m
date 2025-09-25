function [Q,R] = col_updating_qr(Q,R,U)
        V = Q' * U;
        Y = U - Q * V;
        [Q2, R2] = qr(Y, "econ");
        Rl = [V; R2];
        R = [[R;zeros(size(R2,1), size(R,2))]  Rl];
        Q = [Q, Q2];
end