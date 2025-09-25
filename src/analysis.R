# Get the filenames from the csvs directory
filenames <- str_c("./csvs/", list.files("./csvs/"))

# Read in all the datasets
results <- map_df(filenames, read_file)

# Make a plot for the bayer01 matrices
plot_performance(results, 
                 mat_type = "bayer01", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "QRPP_lev_cur", "svds" ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

# Make pot for 20000 low rank PD
plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
)

plot_performance(results,
                 mat_type = "Hilbert", 
                 block_siz = 10, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "QRPP_lev_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 2000
)

plot_performance(results,
                 mat_type = "bayer08", 
                 block_siz = 100,
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
)

plot_performance(results, 
                 mat_type = "igbt3", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_iterative_cur", "QRPP_lev_cur", "svds"),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results, 
                 mat_type = "igbt3", 
                 block_siz = 50, 
                 oversampl = 0, 
                 methods = c("QRPP_iterative_cur", "QRPP_lev_cur", "svds"),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results,
                 mat_type = "Hilbert", 
                 block_siz = 10, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
)

plot_performance(results,
                 mat_type = "Cauchy", 
                 block_siz = 10, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
)

plot_performance(results, 
                 mat_type = "bayer01", 
                 block_siz = 1000, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"  ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results, 
                 mat_type = "c-67", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"  ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results,
                 mat_type = "Cauchy", 
                 block_siz = 10, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "OS_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 400
)

plot_performance(results,
                 mat_type = "venkat01", 
                 block_siz = 100, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "OS_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results,
                 mat_type = "TSOPF", 
                 block_siz = 100, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "OS_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results,
                 mat_type = "Low_Rank", 
                 block_siz = 100, 
                 oversampl = 0,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "OS_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols")
)

plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 100, 
                 oversampl = 20, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 5000
)
plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 100, 
                 oversampl = 0, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 5000
)
plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 100, 
                 oversampl = 50, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 5000
)
plot_performance(results, 
                 mat_type = "Low_Rank_PD", 
                 block_siz = 1600, 
                 oversampl = 1600, 
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 5000
)

block_size_scale <- results %>% 
  filter(mat_label == "Low_Rank_PD",
         block_size %in% c(10, 50, 100, 200, 400, 800, 1600),
         oversample %in% c(10, 50, 100, 200, 400, 800, 1600),
         method %in% c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
         matrix_size == 5000
  ) %>%
  group_by(method, block_size) %>%
  summarise(time = mean(time), n_cols = mean(n_cols), overall_accuracy = mean(overall_accuracy)) 

block_size_scale %>%
  ggplot(aes(x = block_size, y = time, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("Timing")

block_size_scale %>%
  ggplot(aes(x = block_size, y = overall_accuracy, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("Overall Accuracy") +
  scale_y_log10()

block_size_scale %>%
  ggplot(aes(x = block_size, y = n_cols, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("N Cols")

# Look at same scaling when oversample by half of block size
block_size_scale_half <- results %>% 
  filter(mat_label == "Low_Rank_PD",
         block_size %in% c(10, 50, 100, 200, 400, 800, 1600),
         oversample %in% c(5, 25, 50, 100, 200, 400, 800),
         method %in% c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
         matrix_size == 5000
  ) %>%
  group_by(method, block_size) %>%
  summarise(time = mean(time), n_cols = mean(n_cols), overall_accuracy = mean(overall_accuracy)) 

block_size_scale_half %>%
  ggplot(aes(x = block_size, y = time, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("Timing")

block_size_scale_half %>%
  ggplot(aes(x = block_size, y = overall_accuracy, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("Overall Accuracy") +
  scale_y_log10()

block_size_scale_half %>%
  ggplot(aes(x = block_size, y = n_cols, color = method)) +
  geom_line() +
  theme_classic() +
  ggtitle("N Cols")

plot_performance(results,
                 mat_type = "Haar", 
                 block_siz = 100,
                 oversampl = 2,
                 methods = c("QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 1024
)

plot_performance(results,
                 mat_type = "Low_Rank_PD", 
                 block_siz = 200,
                 oversampl = 0.2,
                 methods = c("QRPP_sketch_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
                 
)


plot_performance(results,
                 mat_type = "Low_Rank_PD", 
                 block_siz = 200,
                 oversampl = 0.1,
                 methods = c("QRPP_sketch_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur"),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
                 
)

plot_performance(results,
                 mat_type = "Low_Rank_PD", 
                 block_siz = 200,
                 oversampl = 0.0,
                 methods = c("QRPP_sketch_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 dimension = 20000
                 
)

plot_performance(results,
                 mat_type = "bayer01", 
                 block_siz = 200,
                 oversampl = 0.0,
                 methods = c("QRPP_sketch_cur","QRPP_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 
                 
)

plot_performance(results,
                 mat_type = "bayer01", 
                 block_siz = 200,
                 oversampl = 0.1,
                 methods = c("QRPP_sketch_cur", "QRPP_iterative_cur", "svds", "LUPP_iterative_cur" ),
                 stats = c("overall_accuracy", "time", "n_cols"),
                 
                 
)

bayer01 <- results %>%
  filter(mat_label == "bayer01")

med_results <- results %>% 
  group_by(mat_label, matrix_size, block_size, method, it_limit, oversample) %>%
  summarise(
    time = median(time), 
    n_cols = median(n_cols), 
    n_rows = median(n_rows), 
    overall_accuracy = median(overall_accuracy),
    threshold = median(threshold),
  )


med_results %>%
  filter(it_limit == T, oversample == 0) %>% 
group_by(mat_label, matrix_size, block_size) %>%
  pivot_wider(names_from = c("method"), values_from = c("time", "n_cols", "n_rows", "overall_accuracy")) %>%
  mutate(
    time_perf_svd = time_svds / time_LUPP_iterative_cur, 
    time_perf_sketch = time_LUPP_sketch_cur / time_LUPP_iterative_cur,
    accur_perf_svd = overall_accuracy_svds / overall_accuracy_LUPP_iterative_cur,
    accur_perf_sketch = overall_accuracy_LUPP_sketch_cur / overall_accuracy_LUPP_iterative_cur,
  ) %>%
  ungroup() %>%
  pivot_longer(cols = c(
    "time_perf_svd",
    "time_perf_sketch",
    "accur_perf_svd",
    "accur_perf_sketch",
  ), names_to = "performance_metric", values_to = "value") %>%
  select(mat_label, matrix_size, performance_metric, value) %>% 
  unique() %>%  
  separate(performance_metric, c("Metric", "Comparison"), "_perf_") %>%
  mutate(
    Comparison = str_replace_all(Comparison, "^([a-z])", toupper),
    Metric = str_replace_all(Metric, "^([a-z])", toupper),
  ) %>%
  ggplot() +
  geom_point(aes(matrix_size, value, col = Comparison)) +
  geom_hline(aes(yintercept = 1), col = "red")+
  facet_grid(Metric~.) +
  scale_y_log10() +
  theme_bw()

direct <- "./clean_csvs/synthetic/"
metrics <- c("time", "overall_accuracy", "n_cols")
# Look at the distributions of basic examples starting with Low Rank No Oversampling
bs <- 200
mat_l <- "Low_Rank"
mat_s <- 20000
os_s <- 0
info <- str_c(direct,mat_l, "_", mat_s, "_", bs, "_", os_s)
filter_experiments(results, bs, mat_l, mat_s, os_s) %>%
  box_csv_stat(other_info = info, cols = metrics)

# Look at the distribution of Low Rank PD
bs <- 200
mat_l <- "Low_Rank_PD"
mat_s <- 20000
os_s <- 0
info <- str_c(direct, mat_l, "_", mat_s, "_", bs, "_", os_s)
filter_experiments(results, bs, mat_l, mat_s, os_s) %>%
  box_csv_stat(other_info = info, cols = metrics)

# Look at the distribution of RANDSVD
bs <- 200
mat_l <- "RandSVD"
mat_s <- 10000
os_s <- 0
info <- str_c(direct, mat_l, "_", mat_s, "_", bs, "_", os_s)
filter_experiments(results, bs, mat_l, mat_s, os_s) %>%
  box_csv_stat(other_info = info, cols = metrics)


direct <- "./clean_csvs/over_sample/"
## Now consider the problem of oversampling
bs <- 200
mat_l <-  "Low_Rank_PD"
mat_s <- 20000
info <- str_c(direct, mat_l, "_", mat_s, "_", bs, ".csv")

over_sample_data_set(results, bs, mat_l, mat_s, os_s) %>%
  write_csv(info)

direct <- "./clean_csvs/fixed_size/"
## Now consider the problem of fixed size performance
info1svd <- str_c(direct,"experiments_fixed_svd_better_time.csv")
info2svd <- str_c(direct,"experiments_fixed_svd_worse_time.csv")
info3svd <- str_c(direct,"experiments_fixed_svd_better_accuracy.csv")
info4svd <- str_c(direct,"experiments_fixed_svd_worse_accuracy.csv")
info1lupp <- str_c(direct,"experiments_fixed_lupp_better_time.csv")
info2lupp <- str_c(direct,"experiments_fixed_lupp_worse_time.csv")
info3lupp <- str_c(direct,"experiments_fixed_lupp_better_accuracy.csv")
info4lupp <- str_c(direct,"experiments_fixed_lupp_worse_accuracy.csv")
fixed_ds <- fixed_sample_dat_set(results) %>%
  drop_na() %>%
  # Remove exactly low rank matrices and c-69 because experiments are wrong
  filter(!mat_label %in% c("c-69", "CSphd", "Low_Rank")) 

split_fixed_data(fixed_ds, T, T, T) %>%
  write_csv(info1svd)
split_fixed_data(fixed_ds, T, T, F) %>%
  write_csv(info2svd)
split_fixed_data(fixed_ds, F, T, T) %>%
  write_csv(info3svd)
split_fixed_data(fixed_ds, F, T, F) %>%
  write_csv(info4svd)
split_fixed_data(fixed_ds, T, F, T) %>%
  write_csv(info1lupp)
split_fixed_data(fixed_ds, T, F, F) %>%
  write_csv(info2lupp)
split_fixed_data(fixed_ds, F, F, T) %>%
  write_csv(info3lupp)
split_fixed_data(fixed_ds, F, F, F) %>%
  write_csv(info4lupp)

