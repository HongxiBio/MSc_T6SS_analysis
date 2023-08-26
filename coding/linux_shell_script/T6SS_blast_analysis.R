
T6SS_blast_raw <- read.csv("../../Results/T6SS_identification/T6SS_blast_result.csv",header = F)
protein_names_index <- read.csv("/home/vader/Documents/MSc-project/data/raw_data/T6SS_protein_reference/protein_names_index.csv")

colname_list <- readLines("./T6SS_blast_colname_file.txt")
colnames(T6SS_blast_raw) <- colname_list

T6SS_blast_raw$Query_accession_version <- protein_names_index$target_name[match(T6SS_blast_raw$Query_accession_version, protein_names_index$query_accession)]

write.table(T6SS_blast_raw, file = "../../Results/T6SS_identification/T6SS_blast_result.csv", col.names = T, row.names = F)