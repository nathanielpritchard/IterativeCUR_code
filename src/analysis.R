# This script will use the data in the csvs directory and generate the 
# clean csvs needed to make all plots included in the paper in the threshold 
# examples, block size, and fixed rank sections of the experiments.
# Generating the selection method section requires running the matlab code "selection_test.m"
# running this code requires that you have installed the tidyverse and purrr libraries
# check to make sure your working directory is "IterativeCUR_code/src" 
# Warnings will be produced about NAs ignore these warnings
source("Analyze_distribution.R")
# Get the filenames from the csvs directory
filenames <- str_c("./csvs/", list.files("./csvs/"))

# Read in all the datasets
results <- map_df(filenames, read_file)

#############################################
# Fixed Rank Experiments
#############################################
# get results for block size 250

b250 <- results %>%
  filter(block_size == 250, it_limit) %>% 
  group_by(mat_label, matrix_size, n_cols, method) %>%
  summarise(accuracy = median(overall_accuracy), time = median(time)) %>%
  filter(mat_label != "Low_Rank")

mat_names <- unique(b250$mat_label) 
# make blocks breaking the results into accuracy and time for each matrix
for(m in mat_names){
  acc_name <- str_c("clean_csvs/same_rank/", m, "_250_accuracy.csv")
  time_name <- str_c("clean_csvs/same_rank/", m, "_250_time.csv")

  b250 |> 
    filter(mat_label == m) |> 
    select(-time) |>
    pivot_wider(names_from = c("method"), values_from = c("accuracy")) |>
    write_csv(acc_name)


  b250 |> 
    filter(mat_label == m) |> 
    select(-accuracy) |>
    pivot_wider(names_from = c("method"), values_from = c("time")) |>
    write_csv(time_name)
}

####################################################################
# Look at threshold Experiments running the algorithm as specified
###################################################################
direct <- "./clean_csvs/synthetic/"
metrics <- c("time", "overall_accuracy", "n_cols")
# Look at the distributions of synthetic examples where IterativeCUR run with fixed blocksize
# Create list of matrix label (entry 1), size (entry 2), and blocksize (entry 3) values
synthetic <- list(
  c("bayer01", 57735, 250), c("c-67",57975, 250), c("c-69", 67458, 250), c("Cauchy", 30000, 10),
  c("ct20stif", 52329, 250), c("g7jac200", 59310, 250), c("Hilbert", 30000, 10), 
  c("Low_Rank", 30000, 250), c("Low_Rank_PD", 30000, 250), c("mark3", 64089, 250),
  c("RandSVD", 30000, 250), c("TSOPF", 76216,250), c("venkat01", 62424, 250), c("randLOW", 70000,250)
)
for(dat in synthetic){
  info <- str_c(direct,dat[1], "_", dat[2], "_", dat[3], "_", 0)
  filter_experiments(results, as.numeric(dat[3]), dat[1], as.numeric(dat[2]), 0) %>%
    box_csv_stat(other_info = info, cols = metrics)
}

###########################
# Block Size Experiments
###########################

# Filter data to block size experiment results
bs_experiments <- results %>% 
  filter(n_cols %in% c(500, 1000,1500,2000, 2500), block_size %in% c(1,5,50,100,500), method == "LUPP_iterative_cur")%>%
  mutate(block_size = str_c("bs_", block_size))

# Generate CSVs for potting block size Experiments
direct <- "./clean_csvs/block_size/"
for(na in c( "RandSVD", "Low_Rank_PD", "bayer01")){
  accur_name <- str_c(direct, na, "_accuracy.csv")
  time_name <- str_c(direct, na, "_time.csv")
  bs_experiments |>
    filter(mat_label == na) |>
    select(time, block_size, n_cols) |>
    group_by(n_cols, block_size) |> 
    summarise(time = median(time)) |> 
    pivot_wider(names_from = block_size, values_from = time) |>
    write_csv(time_name)
  
  bs_experiments |>
    filter(mat_label == na) |>
    select(overall_accuracy, block_size, n_cols) |>
    group_by(n_cols, block_size) |> 
    summarise(overall_accuracy = median(overall_accuracy)) |> 
    pivot_wider(names_from = block_size, values_from = overall_accuracy) |>
    write_csv(accur_name)
  
}
