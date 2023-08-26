library(gggenes)
library(ggplot2)
library(ggfittext)
library(dplyr)

testdata <- subset(range_T6SS_positive, subset = accession == "GCF_018176755.1")

testdata <- range_T6SS_list[["GCF_018176755.1"]]

# group each genes by the critera:
# any two adjacent genes with a start position difference greater than 20000 bases are considered to be in different groups

threshold <- 20000
group_the_ranges <- function(df,threshold) {
  df <- arrange(df,start)
  df$group <- cumsum(c(1, diff(df$start) > threshold))
  return(df)
}
# apply the function 
range_T6SS_list <- lapply(range_T6SS_list, group_the_ranges, threshold = threshold)

# generate T6SS plots 
# set the function
draw_T6SS <- function(df) {
  T6SS_plot <- ggplot(df, aes(xmin = start, xmax = end, y = orientation, fill = sequence_code, label = sequence_code, forward = orientation == "forward")) +
    geom_gene_arrow() +
    geom_gene_label(align = "left") +
    facet_grid(cols = vars(group), scales = "free", space = "fixed") +
    scale_fill_brewer(palette = "Set3",name = "sequence_code") +
    theme_genes()
  return(T6SS_plot)
}

# apply the function
range_T6SS_plots <- lapply(range_T6SS_list,draw_T6SS)

# output the plots
for (i in seq_along(range_T6SS_plots)) {
  
  plot_name <- names(range_T6SS_plots)[i]
  file_name <- paste0("../../Results/T6SS_identification/T6SS_plots/",plot_name,".png")
  
  ggsave(file_name, plot = range_T6SS_plots[[i]],width = 12, height = 4, device = "png")
}


# determine the range of each groups
  testdata_group_list <- split(testdata, testdata$group) 
  
  find_the_ranges <- function(df) {
    seq_ranges <- data.frame(accession = unique(df$accession), start = min(df$start), end = max(df$end), type = unique(df$type) , group = unique(df$group))
    return(seq_ranges)
  }

  whole_ranges_location <- lapply(testdata_group_list, find_the_ranges)
  whole_ranges_location <- do.call(rbind,whole_ranges_location)

View(example_genes)
