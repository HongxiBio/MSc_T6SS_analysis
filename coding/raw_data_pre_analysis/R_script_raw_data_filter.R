library(readxl)

metadata <- read_xlsx("../../data/metadata/metadata_for_RefSeq.xlsx")

colnames(metadata) <- gsub("\\s", "_", colnames(metadata))

write.table(metadata,file = "../../data/metadata/metadata_for_RefSeq.xlsx", row.names = F)

available_datasets <- subset(metadata, Assembly_Stats_Number_of_Contigs <= 200 
                             & Assembly_Stats_Total_Sequence_Length < 2000000 
                             & Assembly_Stats_Total_Sequence_Length > 1400000
                             & ANI_Check_status == "OK"
                             & ANI_Best_ANI_match_ANI >= 96
                             & ANI_Best_ANI_match_Organism == "Campylobacter jejuni")


writeLines(available_datasets$Assembly_Accession, con = "../../Results/datasets_used/used_accession_list.txt")
write.table(available_datasets, file = "../../Results/datasets_used/datasets_used_in_analysis.csv", row.names = F)
