library(IRanges)
library(dplyr)
library(tidyr)

T6SS_blast_result <- read.csv("../../Results/T6SS_identification/T6SS_blast_result.csv", sep = ",")

T6SS_positive_list <- data.frame(readLines("./T6SS_positive_list.txt"))
colnames(T6SS_positive_list) <- "accession"
individual_blast_raw <- read.csv("../../Results/individual_blast_NCTC11168.csv", sep = " ")



T6SS_positive_genome_matches <- merge(individual_blast_raw, T6SS_positive_list, 
                                      by.x = "Query_accession_version", 
                                      by.y = "accession" , 
                                      all.y = T)
T6SS_positive_genome_matches <- subset(T6SS_positive_genome_matches,
                                       select = c("Query_accession_version", "Start_of_alignment_in_query", "End_of_alignment_in_query"))
T6SS_positive_genome_matches$type <- "covers"

colnames(T6SS_positive_genome_matches) <- c("accession","start","end","type")



T6SS_positive_T6SS_sequences <- merge(T6SS_blast_result,T6SS_positive_list, 
                                      by.x = "Subject_accession_version", 
                                      by.y = "accession", 
                                      all.y = T)
T6SS_positive_T6SS_sequences <- subset(T6SS_positive_T6SS_sequences,
                                       select = c("Subject_accession_version","Start_of_alignment_in_subject","End_of_alignment_in_subject"))
T6SS_positive_T6SS_sequences$type <- "T6SS"

colnames(T6SS_positive_T6SS_sequences) <- c("accession","start","end", "type")



merged_T6SS_gaps <- rbind(T6SS_positive_T6SS_sequences,T6SS_positive_genome_matches)

#build a function to make sure start point < end point, for the limitation of IRanges 
swap_start_end_for_T6SS <- function(data) {
  # get the rows that need to be swaped 
  rows_to_swap <- data$start > data$end
    # swap the start and end value 
  data[rows_to_swap, c("start", "end")] <- data[rows_to_swap, c("end", "start")]
  
  # return the swaped data
  return(data)
}

merged_T6SS_gaps <- swap_start_end_for_T6SS(merged_T6SS_gaps)

ranges_in_genomes <- split(merged_T6SS_gaps,merged_T6SS_gaps$accession)

find_the_ICE <- function(df) {
  accession <- unique(df$accession)
  covers <- subset(df, df$type == "covers")
  T6SS <- subset(df, df$type == "T6SS")
  covers_in_genome <- IRanges(start = covers$start, end = covers$end)
  gaps_in_genome <- gaps(reduce(covers_in_genome))
  T6SS_ranges <- IRanges(start = T6SS$start, end = T6SS$end)
  gaps_with_T6SS <- gaps_in_genome[overlapsAny(gaps_in_genome,T6SS_ranges)]
  ICE_range <- reduce(c(T6SS_ranges,gaps_with_T6SS))
  ICE <- c(min(start(ICE_range)),max(end(ICE_range)),accession)
  
  return(ICE)
}

ICE_ranges <- lapply(ranges_in_genomes,find_the_ICE)
ICE_ranges <- data.frame(do.call(rbind,ICE_ranges))
rownames(ICE_ranges) <- NULL
colnames(ICE_ranges) <- c("start","end","accession")
ICE_ranges$start <- as.numeric(ICE_ranges$start)
ICE_ranges$end <- as.numeric(ICE_ranges$end)
ICE_ranges$length <- ICE_ranges$end - ICE_ranges$start
