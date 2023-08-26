T6SS_list_with_whole_genome <- data.frame(readLines("./T6SS_with_WGS_accession_list.txt"))
T6SS_positive_list <- data.frame(readLines("../../../Results/T6SS_identification/T6SS_positive_list.txt"))
blast_result_for_NCTC11168 <- read.csv("../../../Results/gaps_determining/RefSeq_blast_NCTC11168.csv",sep = " ")

library(IRanges)
library(dplyr)
library(tidyr)

colnames(T6SS_positive_list) <- "assembly_accession"
colnames(T6SS_list_with_whole_genome) <- "assembly_accession"

blast_result_with_WGS <- merge(blast_result_for_NCTC11168,T6SS_list_with_whole_genome,by = "assembly_accession",all.y = T)

accession_list <- split(blast_result_with_WGS, blast_result_with_WGS$assembly_accession)



test_data <- subset(blast_result_with_WGS, 
                    subset = assembly_accession =="GCF_001870105.1",
                    select = -c(`Query_accesion.version`,`Subject_accession.version`))

cover_range <- IRanges(start = test_data$Start_of_alignment_in_query, end = test_data$End_of_alignment_in_query)

total_range <- IRanges(start = 1, end = unique(test_data$Query_sequence_length))

combined_cover_range <- reduce(cover_range, min.gapwidth = 0L)

uncover_range <- setdiff(total_range, combined_cover_range)

print(uncover_range)

test_data_uncover <- data.frame(uncover_range)
