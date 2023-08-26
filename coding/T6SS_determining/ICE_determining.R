library(IRanges)
library(dplyr)
library(tidyr)

T6SS_blast_result <- read.csv("../../Results/T6SS_identification/T6SS_blast_result.csv", sep = ",")

T6SS_positive_list <- data.frame(readLines("./T6SS_positive_list.txt"))
colnames(T6SS_positive_list) <- "accession"
individual_blast_raw <- read.csv("../../Results/individual_blast_NCTC11168.csv", sep = " ")


#determining the gaps in the genomes that are T6SS positive
T6SS_positive_genome_matches <- merge(individual_blast_raw, T6SS_positive_list, 
                                      by.x = "Query_accession_version", 
                                      by.y = "accession" , 
                                      all.y = T)

respectively_genomes <- split(T6SS_positive_genome_matches,T6SS_positive_genome_matches$Query_accession_version)

find_the_gaps <- function(df) {
  covers <- IRanges(start = df$Start_of_alignment_in_query, end = df$End_of_alignment_in_query)
  merged_covers <- reduce(covers)
  gaps <- data.frame(gaps(merged_covers))
  gaps$accession <- unique(df$Query_accession_version)
  return(gaps)
}

gaps_determined <- lapply(respectively_genomes, find_the_gaps) 

gaps_in_genome <- do.call(rbind, gaps_determined)
rownames(gaps_in_genome) <- NULL
gaps_in_genome$type <- "gaps"


#determing the T6SS proteins sequence ranges 
T6SS_positive_T6SS_sequences <- merge(T6SS_blast_result,T6SS_positive_list, 
                                      by.x = "Subject_accession_version", 
                                      by.y = "accession", 
                                      all.y = T)

#build a function to make sure start point < end point, for the limitation of IRanges 
swap_start_end_for_T6SS <- function(data) {
  # get the rows that need to be swaped 
  rows_to_swap <- data$Start_of_alignment_in_subject > data$End_of_alignment_in_subject
  
  # swap the start and end value 
  data[rows_to_swap, c("Start_of_alignment_in_subject", "End_of_alignment_in_subject")] <- data[rows_to_swap, c("End_of_alignment_in_subject", "Start_of_alignment_in_subject")]
  
  # return the swaped data
  return(data)
}


T6SS_positive_T6SS_sequences <- swap_start_end_for_T6SS(T6SS_positive_T6SS_sequences)

respectively_T6SS <- split(T6SS_positive_T6SS_sequences,T6SS_positive_T6SS_sequences$Subject_accession_version)


find_the_T6SS_ranges <- function(df) {
  covers <- IRanges(start = df$Start_of_alignment_in_subject, end = df$End_of_alignment_in_subject)
  covers <- reduce(covers)
  covers <- data.frame(covers)
  covers$accession <- unique(df$Subject_accession_version)
  return(covers)
}

T6SS_ranges <- lapply(respectively_T6SS, find_the_T6SS_ranges)

T6SS_in_genome <- do.call(rbind, T6SS_ranges)
rownames(T6SS_in_genome) <- NULL
T6SS_in_genome$type <- "T6SS"

#determining the gap with T6SS
merged_T6SS_gaps <- rbind(gaps_in_genome,T6SS_in_genome)
merged_T6SS_gaps_list <- split(merged_T6SS_gaps,merged_T6SS_gaps$accession)

determing_the_gaps_with_T6SS <- function (df) {
 gaps <- subset(df,type == "gaps") 
 T6SS <- subset(df,type == "T6SS")
 
}
