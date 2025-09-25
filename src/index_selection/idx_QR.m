function [I, start] = idx_QR(Res, block_size, I, start)
   Res(:, I(I > 0)) = 0;
   [~, ~, P] = qr(Res, "econ", "vector");
   end_idx = start + block_size - 1;
   I(start:end_idx) = P(1:block_size)';
   start = end_idx + 1;
end