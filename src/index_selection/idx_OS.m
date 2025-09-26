function  [I, start] = idx_OS(Res, block_size, I, start)
    % Function that uses osinsky for column selection 
    Res(:, I(I > 0)) = 0;
    [~, ~, V] = svd(Res, "econ", "vector");
    end_idx = start + block_size - 1;
    [I(start:end_idx), ~, ~] = Osinsky_sketchnorm(Res, V(:, 1:block_size));
    start = end_idx + 1;
end