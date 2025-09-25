function [Bnorm] = BigNormSVD(A,S)
    % Computes the Fro norm of a really big matrix
    % compared to SVD low rank approximation
    nA = norm(A, 'fro')^2;
    Bnorm = sqrt(nA - norm(S, 'fro')^2);
end