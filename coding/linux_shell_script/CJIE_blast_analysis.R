
CJIE_blast_raw <- read.csv("../../Results/CJIE_determining/CJIE_blast_result.csv",header = F)
colname_list <- readLines("./T6SS_blast_colname_file.txt")
colnames(CJIE_blast_raw) <- colname_list

write.table(CJIE_blast_raw, file = "../../Results/CJIE_determining/CJIE_blast_result.csv", col.names = T, row.names = F)