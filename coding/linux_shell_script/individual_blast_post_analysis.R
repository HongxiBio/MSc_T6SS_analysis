#this script should only runs ONE TIME!!! in test datasets. for each analysis. 
library(tidyr)

folder_path <- "../../data/processed_data/CJ_RefSeq/ncbi_dataset/data/"
output_path <- "../../Results/CJIE_determining/individual_blast_CJIE.csv"
col_name_list <- readLines("individual_blast_colname_file.txt")

subfolders <- list.files(folder_path, full.names = T, recursive = F)

for (subfolder in subfolders) {
  blast_out_file <- file.path(subfolder, "CJIE_blast_result.csv")
  
  if (file.exists(blast_out_file)) {
    file_info <- file.info(blast_out_file)
    file_size <- file_info$size
    
    if (file_size > 0) {
      data <- read.csv(blast_out_file)
      colnames(data) <- col_name_list
      write.csv(data, file = blast_out_file, row.names = FALSE)
      write.table(data, file = output_path, append = TRUE, col.names = FALSE, row.names = FALSE)
    } else {
      cat("Warning: The file", blast_out_file, "is empty. Skipping processing.\n")
    }
  } else {
    cat("Warning: The file", blast_out_file, "does not exist.\n")
  }
}

final_out <- read.csv(output_path, sep = " ")
colnames(final_out) <- col_name_list

final_out <- separate(final_out,Query_accession_version,into = c("query_accession","locus"), sep = "\\|")
final_out <- separate(final_out,locus, into = c("locus","prortein_accessioin"), sep = "_cds_")

write.table(final_out,file = output_path, col.names = T, row.names = F)
