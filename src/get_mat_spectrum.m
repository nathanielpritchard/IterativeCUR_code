addpath("./matrix_generation")
mat_list = ["CSphd", "igbt3", "venkat01", "YaleB", "mark3", "bayer08", "c-67", "c-69"]; %"Hilbert", "RandSVD", "Cauchy",  "bcircuit", "ct20stif", "TSOPF",  "bayer01", "g7jac200"];%, 
for i = 1:8
    A = mat_gen(mat_list(i), 20000, 2000);
    [~,S,~, ~] = svdsketch(A, 1e-5);
    var_names = ["svs"];
    tib = table(diag(S), 'VariableNames',var_names);
    filename = append("spec/",mat_list(i),".csv");
    writetable(tib, filename);
end
