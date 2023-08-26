#this script should only runs ONE TIME!!! for each analysis. 

folder_path <- "../../../data/processed_data/RefSeq_available_for_analysis/"
output_path <- "../../../Results/gaps_determining/RefSeq_blast_NCTC11168.csv"
col_name_list <- readLines("individual_blast_colname_file.txt")

subfolders <- list.files(folder_path, full.names = T, recursive = F)

for (subfolder in subfolders) {
  
  blast_out_file <- file.path(subfolder, "blast_result.csv")
  
  if (file.exists(blast_out_file)){
    
    data <- read.csv(blast_out_file)
    
    colnames(data) <- col_name_list
    
    data$assembly_accession <- basename(subfolder)
    
    write.csv(data, file = blast_out_file, row.names = F)
    write.table(data,file = output_path, append = T, col.names = F, row.names = F)
  }
}

final_out <- read.csv(output_path, sep = " ")
colnames(final_out) <- c(col_name_list,"assembly_accession")

write.table(final_out,file = output_path, col.names = T, row.names = F)