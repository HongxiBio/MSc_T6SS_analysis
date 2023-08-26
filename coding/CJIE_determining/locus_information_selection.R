#this scirpt is used to isolate each locus' information of name, length, and their order in genomes. source data comes from .gbff file 

library(tidyr)

#set work directory to the target folders
setwd("/home/vader/Documents/MSc-project/data/processed_data/CJ_RefSeq/ncbi_dataset/data")

#get all the folder path into a list
folder_list <- list.files("./",recursive = F, full.names = T)

get_locus_info <- function(folder_path){
  
  folder_name <- basename(folder_path)
  file_path <- file.path(folder_path,"genomic.gbff")
  
  locus_lines <- grep("^LOCUS", readLines(file_path), value = TRUE)
  
  locus_list <- lapply(strsplit(locus_lines,"\\s+"),function(x) x[x != ""])
  
  locus <- data.frame(do.call(rbind, locus_list))
  colnames(locus) <- c("keyword","locus_accession","length","unite","type","topology","division","date")
  
  locus <- subset(locus, select = c("locus_accession","length"))
  locus$length <- as.numeric(locus$length)

  locus$start <- cumsum(locus$length) - locus$length + 1
  locus$end <- cumsum(locus$length)
  
  locus$accession <- folder_name
  
  return(locus)
}

#proceed the analysis for each folder path in the list
all_locus <- lapply(folder_list, get_locus_info)

#data wash for better understanding
all_locus_combined <- do.call(rbind,all_locus)
  
#output result
write.csv(all_locus_combined, file = "/home/vader/Documents/MSc-project/data/processed_data/CJ_RefSeq/all_locus_info.csv",row.names = F)
