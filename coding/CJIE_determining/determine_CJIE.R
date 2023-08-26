library(dplyr)

CJIE_blast <- read.csv("/home/vader/Documents/MSc-project/Results/individual_blast_CJIE.csv", sep = " ")

T6SS_positive_list <- data.frame(readLines("/home/vader/Documents/MSc-project/coding/T6SS_determining/T6SS_positive_list.txt"))
colnames(T6SS_positive_list) <- "accession"

CJIE_in_T6SS <- merge(CJIE_blast,T6SS_positive_list, by.x = "query_accession", by.y = "accession")
length(unique(CJIE_in_T6SS$query_accession))

# combine the locus information with blast result
  locus_info <- read.csv("/home/vader/Documents/MSc-project/data/processed_data/CJ_RefSeq/all_locus_info.csv")
  CJIE_in_T6SS$locus <- sub("\\..*", "", CJIE_in_T6SS$locus)
  CJIE_in_T6SS_full <- merge(CJIE_in_T6SS,locus_info, by.x = c("query_accession","locus"), by.y = c("accession","locus_accession"), all.x = T) 
# check if there is any empty value in the merged data (optional)
  any(is.na(CJIE_in_T6SS_full$Alignment_length))

# caculate the start and end point in genome
  CJIE_in_T6SS_full$query_start_point_in_genome <- CJIE_in_T6SS_full$Start_of_alignment_in_query + CJIE_in_T6SS_full$start
  CJIE_in_T6SS_full$query_end_point_in_genome <- CJIE_in_T6SS_full$End_of_alignment_in_query + CJIE_in_T6SS_full$end


# make separate table for each accession
CJIE_in_T6SS_by_list <- split(CJIE_in_T6SS_full,CJIE_in_T6SS$query_accession) 


# output the blast_results_with genome location
  write.csv(CJIE_in_T6SS_full,"/home/vader/Documents/MSc-project/Results/CJIE_with_T6SS_blast.csv", row.names = F)

# generate a very breif summary for each accession
  summary_CJIE <- function(df) {
    accession <- unique(df$query_accession)
    n <- nrow(df)
    num_of_cog <- length(unique(df$locus))
    num_of_match <- length(unique(df$Subject_accession_version))
    summary_info <- data.frame(accession = accession, number_of_rows = n, number_of_locus = num_of_cog, number_of_match = num_of_match)
    return(summary_info)
  }
  
  CJIE_summary <- lapply(CJIE_in_T6SS_by_list, summary_CJIE)
  
  CJIE_summary <- do.call(rbind,CJIE_summary)
  rownames(CJIE_summary) <- NULL
  View(CJIE_summary)


# analysis the blast result
  
    
    