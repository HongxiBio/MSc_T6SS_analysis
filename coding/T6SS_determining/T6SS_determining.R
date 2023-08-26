# this scirpt is used to determine the presence of at leat 11 out of 14 T6SS compoments
library(tidyr)
library(readxl)
library(gggenes)
library(ggplot2)
library(ggfittext)
library(dplyr)

# load the data
  T6SS_blast_raw <- read.csv("../../Results/T6SS_identification/T6SS_blast_result.csv",header = T, sep = " ")
  metadata <- read.csv("../../data/metadata/metadata_for_RefSeq.xlsx", sep = " ")
  locus_info <- read.csv("../../data/processed_data/CJ_RefSeq/all_locus_info.csv")

# wash the data for merge locus with locus information
  T6SS_blast_raw$Subject_accession_version <- sub("\\..*", "", T6SS_blast_raw$Subject_accession_version)
  T6SS_blast_raw <- merge(T6SS_blast_raw, locus_info, by.x = "Subject_accession_version", by.y = "locus_accession", all.x = T)

# determining T6SS positive results
  # calculate the hits' coverage proportion in query protein 
    T6SS_blast_raw$hit_coverage <- T6SS_blast_raw$Alignment_length / T6SS_blast_raw$Query_sequence_length
  
  # select the qualified results from blast results
    T6SS_blast_available <- subset(T6SS_blast_raw, 
                           subset = Percentage_of_identical_matches >=50 & hit_coverage >= 0.5,
                           select = c("Query_accession_version","accession")) 
  
  # calculate the frequency of hits for each protein and clean the data
    T6SS_blast_available <- T6SS_blast_available %>% group_by(Query_accession_version, accession) %>% mutate(frequency = n())
    T6SS_blast_available <- distinct(T6SS_blast_available)
  
  # change the data format from long-data to wide-data
    T6SS_blast_available_wide <- spread(T6SS_blast_available, key = Query_accession_version, value = frequency, fill = 0)
  
  # calculate how many proteins are present in each genome
    T6SS_blast_available_wide$target_score <- rowSums(T6SS_blast_available_wide != 0) -1
  
  # select the presence of proteins that less than 11 in 13 
    T6SS_positive_result <- subset(T6SS_blast_available_wide,
                                 target_score >= 11)
  
  # generate a simpler table of the result
    T6SS_positive_simple <- subset(T6SS_positive_result,
                                 select = c("accession","target_score"))
  
  # combine the T6SS positive result with metadata
    T6SS_with_metadata <- merge(T6SS_positive_simple, metadata, by.x = "accession", by.y = "Assembly_Accession", all.x = T)
  
  # output the relative results into result folder
    write.table(T6SS_positive_result, file = "../../Results/T6SS_identification/T6SS_positive_protein_detail.csv" )
    write.table(T6SS_with_metadata, file = "../../Results/T6SS_identification/T6SS_positive_metadata.csv" )
    writeLines(T6SS_positive_simple$accession, "../../Results/T6SS_identification/T6SS_positive_list.txt")
    write.table(T6SS_blast_raw, file = "../../Results/T6SS_identification/T6SS_blast_result_post_analysised.csv", sep = ",", row.names = F)

remove(locus_info,metadata)

# find out the T6SS positive ranges
  # select qualified results
  range_T6SS <- subset(T6SS_blast_raw, 
                       subset = Percentage_of_identical_matches >=50 & hit_coverage >= 0.5) 
  
  # calculate start and end point in genome
  range_T6SS$start_in_genome <- range_T6SS$Start_of_alignment_in_subject + range_T6SS$start
  range_T6SS$end_in_genome <- range_T6SS$End_of_alignment_in_subject + range_T6SS$start
  
  # select T6SS positive results
  range_T6SS_positive <- merge(range_T6SS,T6SS_positive_simple, by = "accession", all.y = T)
  
  # determine the direction for each genes for graph generation 
  range_T6SS_positive <- subset(range_T6SS_positive, select = c("Query_accession_version","accession","start_in_genome","end_in_genome"))
  range_T6SS_positive$orientation <- ifelse(range_T6SS_positive$end_in_genome < range_T6SS_positive$start_in_genome, "reverse", "forward")
  range_T6SS_positive$type <- "T6SS"
  
  # rename col name
  colnames(range_T6SS_positive) <- c("sequence_code","accession","start","end","orientation","type")
  
  #build a function to make sure start point < end point
  swap_start_end <- function(data) {
    # get the rows that need to be swiped 
    rows_to_swap <- data$orientation == "reverse"
    
    # swap the start and end value 
    data[rows_to_swap, c("start", "end")] <- data[rows_to_swap, c("end", "start")]
    
    # return the swiped data
    return(data)
  }
  # apply the function
  range_T6SS_positive <- swap_start_end(range_T6SS_positive)
  # split the data
  range_T6SS_list <- split(range_T6SS_positive,range_T6SS_positive$accession)
  
  # group each genes by the criteria:
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
  find_all_ranges <- function(data) {
    
    accession_gene_list <- split(data,data$group)
    
    find_the_ranges <- function(df) {
      seq_ranges <- data.frame(accession = unique(df$accession), start = min(df$start), end = max(df$end), type = unique(df$type) , group = unique(df$group))
      return(seq_ranges)
    }
    
    accession_range_list <- lapply(accession_gene_list, find_the_ranges)
    accession_range_list <- do.call(rbind,accession_range_list)
    
    return(accession_range_list)
  }
  
  whole_ranges_location <- lapply(range_T6SS_list,find_all_ranges)
  whole_ranges_location <- do.call(rbind,whole_ranges_location)
  