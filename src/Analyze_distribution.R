setwd("~/Documents/Research/YujiRandNLA/fast_cur/IterativeCUR_modular")
library(tidyverse)
library(purrr)
library(cowplot)
# Define function to read the file and add columns indicated in file name
read_file <- function(filename) {
  # some files end in number but they have
  mat_dim <- str_split(filename, "([A-Z]_|[a-z]_|[a-z][0-9]+_|[a-z]-[0-9][0-9]_)")[[1]]
  l <- length(mat_dim)
  numerical_info <- mat_dim[l] %>%
    str_split("\\.csv", simplify = T)
  alg_stats <- numerical_info[,1] %>%
    str_split("_", simplify = T) %>%
    as.numeric()
  if(length(alg_stats) == 3){
  return(
        read_csv(filename) %>%
          mutate(
            matrix_size = rep(alg_stats[1], nrow(.)),
            block_size = rep(alg_stats[2], nrow(.)),
            oversample = rep(alg_stats[3], nrow(.)),
            it_limit = rep(F, nrow(.))
                 ) 
      )
  }else{
        read_csv(filename) %>%
          mutate(
            matrix_size = rep(alg_stats[1], nrow(.)),
            block_size = rep(alg_stats[2], nrow(.)),
            oversample = rep(alg_stats[3], nrow(.)),
            it_limit = rep(if_else(alg_stats[4] == 0, F, T), nrow(.))
                 ) 
      
  }
}

draw_label_theme <- function(label, theme = NULL, element = "text", ...) {
  if (is.null(theme)) {
    theme <- ggplot2::theme_get()
  }
  if (!element %in% names(theme)) {
    stop("Element must be a valid ggplot theme element name")
  }
  
  elements <- ggplot2::calc_element(element, theme)
  
  cowplot::draw_label(label, 
                      fontfamily = elements$family,
                      fontface = elements$face,
                      colour = elements$color,
                      size = elements$size,
                      ...
  )
}
# Write function to produce plots 
# function can return no more than 7 plots
plot_performance <- function(results, mat_type, block_siz, oversampl, methods, stats, dimension = 0, it_lim = F)
{
  n_plots <- length(stats)
  plots <- vector(mode = "list", n_plots + 1)
  
  filtered_data <- results %>%
    filter(
      mat_label == mat_type,
      block_size == block_siz,
      oversample == oversampl,
      it_limit == it_lim,
      method %in% methods
    ) %>%
    mutate(
      Method = str_replace_all(method, "_([a-z])", toupper) %>%
             str_replace_all("_", " ")
      ) %>%
    mutate(
      Method = if_else(Method == "svds", "SVDsketch", Method),
      Method = str_replace(Method, "QRPP", "QRCP"),
      overall_accuracy = if_else(is.nan(overall_accuracy), pmax(left_accuracy, right_accuracy), overall_accuracy)
    ) %>%
    left_join(tibble(method = methods) %>% 
                mutate(value = row_number())
              ) %>%
    mutate(Method = fct_reorder(Method, value))
  
  if(dimension != 0)
  {
    filtered_data <- filtered_data %>%
      filter(matrix_size == dimension)
  }
  
  title_mat <- str_replace_all(mat_type, "_", " ") %>% str_to_title()
  overall_title <- str_c(title_mat, " of dimension ", unique(filtered_data$matrix_size)[1], " and block size ", unique(filtered_data$block_size)[1])
  
  plots[[1]] <-  ggplot() +
    labs(title = overall_title) + 
    theme_void() +
    theme(plot.title = element_text(face = "bold"),
          line = element_blank()
          ) 

  
  for(i in 1:n_plots){
    stat <- stats[i]
    title_stat <-  x_axis <- str_replace_all(stat, "_", " ") %>% str_to_title()
    plot_title <- str_c("Distributional Comparison of ", title_stat)
    plots[[i+1]] <- filtered_data %>% 
      ggplot(aes(x = .data[[stat]], color = Method)) +
        geom_boxplot() +
        scale_x_log10() +
        theme_classic() +
      theme(
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
      ) +
      ggtitle(plot_title) +
      xlab(title_stat) +
      scale_color_manual(values = c("#94B9AF", "#FF570A", "#979552",  "#301446",  "#773124", "#9D8420", "#8D1339", "#593837"))
  }
  return( plot_grid(plotlist = plots, nrow = n_plots + 1, rel_heights = c(0.15, rep(1, n_plots))) )
}

box_csv_stat <- function(data, other_info, cols)
{
  # for this plug in a dataset filtered to the data points you want enter this info in `other_info`
  # then the function makes a dataset for each statistic included in cols
  # this allows you to easily make boxplots
  for(co in cols){
    filename <- str_c(other_info, "_", co,".csv", sep = "")
    data %>% 
      select(sample, threshold,  method, all_of(co)) %>%
      pivot_wider(names_from = method, values_from = co) %>%
      select(-sample) %>%
      write_csv(filename)
  }
}

filter_experiments <- function(results, b_size, mat_lab, mat_size, os_size){
  results %>% 
    filter(mat_label == mat_lab, 
           it_limit == F, 
           block_size == b_size, 
           matrix_size == mat_size,
           oversample == os_size
    ) %>%
    return()
}

over_sample_data_set <- function(results, b_size, mat_lab, mat_size, os_size){
  # Function that generates datasets for the oversampling experiments
  return(
    results %>%
      filter(mat_label== mat_lab, matrix_size == mat_size, block_size == b_size, it_limit == F) %>% 
      filter(method %in% c("LUPP_iterative_cur", "svds")) %>%
      group_by(mat_label, matrix_size, block_size, oversample, method) %>%
      summarise(
        time = median(time), 
        n_cols = median(n_cols), 
        n_rows = median(n_rows), 
        overall_accuracy = median(overall_accuracy),
        threshold = median(threshold),
      ) %>% 
      pivot_wider(names_from = c("method"), values_from = c("time", "n_cols", "n_rows", "overall_accuracy"))
  )
}

per_diff <- function(x, y){
  return(
    (y - x) / x
  )
}

fixed_sample_dat_set <- function(results){
  # Function that returns datasets when it_limit is true
  return(
    results %>%
      filter(it_limit == T) %>%
      #filter(mat_label== mat_lab, matrix_size == mat_size, block_size == b_size, it_limit == F) %>% 
      filter(method %in% c("LUPP_iterative_cur", "svds", "LUPP_sketch_cur")) %>%
      group_by(mat_label, matrix_size, block_size, oversample) %>%
      mutate(n_cols = min(n_cols)) %>% 
      group_by(mat_label, matrix_size, block_size, oversample, method) %>%
      summarise(
        n_cols = max(n_cols),
        time = median(time), 
        overall_accuracy = median(overall_accuracy),
        threshold = median(threshold),
      ) %>% 
      pivot_wider(names_from = c("method"), values_from = c("time", "overall_accuracy")) %>%
      ungroup() %>% 
      mutate(
        p_time_svd = per_diff(time_LUPP_iterative_cur, time_svds),
        p_time_LUPP = per_diff(time_LUPP_iterative_cur, time_LUPP_sketch_cur),
        p_acc_svd = per_diff(overall_accuracy_LUPP_iterative_cur, overall_accuracy_svds),
        p_acc_LUPP = per_diff(overall_accuracy_LUPP_iterative_cur, overall_accuracy_LUPP_sketch_cur),
        ) %>% 
      select(mat_label, n_cols, matrix_size, block_size, oversample, p_time_svd, p_time_LUPP, p_acc_svd, p_acc_LUPP)
  )
}

split_fixed_data <- function(dataset, time_m = F, svd_m = F, better_than_it = F){
  # Function splits the fixed results across method and accuracy dimensions
  # will either return a better or worse version for each
  metric_n <- ifelse(time_m, "time", "acc")
  method_n <- ifelse(svd_m, "svd", "LUPP")
  c_name <- str_c("p_", metric_n, "_", method_n)
  selected_ds <- dataset %>%
    select(mat_label, n_cols, matrix_size, block_size, oversample, all_of(c_name))
  if(better_than_it){
    return(
      selected_ds %>%
        rename(metric = (c_name)) %>%
        filter(metric >= 0)
    )
  } else {
    return(
      selected_ds %>%
        rename(metric = (c_name)) %>%
        filter(metric < 0)
        
    )
  }

}
