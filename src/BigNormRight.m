function [Bnorm] = BigNormRight(A,Qr)
    % Computes the Fro norm of a really big matrix
    % compared to SVD low rank approximation
    [rows, cols] = size(A);
    Bnorm = 0;
    bsize = min(1000, cols);
    nsteps = fix(cols/bsize);
    rmd = rem(cols, bsize);
    start = 1;
    for i = 1:nsteps
        endp = start + bsize - 1;
        Bnorm = Bnorm + norm(A(:, start:endp) - A*(Qr*Qr(start:endp,:)'), 'fro')^2;
        start = endp + 1;
    end
    if rmd ~= 0
        Bnorm = Bnorm + norm(A(:, (cols-rmd+1):cols) - A*(Qr*Qr((cols-rmd+1):cols,:)'), 'fro')^2;
    end
    Bnorm = sqrt(Bnorm);
end