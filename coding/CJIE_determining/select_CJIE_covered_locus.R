setwd("/home/vader/Documents/MSc-project_test/data/processed_data/test/data/GCF_904845205.1")
testDNA <- readDNAStringSet("GCF_904845205.1_P170201_genomic.fna")

testDNA[1]


setwd("/home/vader/Documents/MSc-project/coding/CJIE_determining")

CJIE_ranges <- read.csv("../../Results/CJIE_determining/potential_CJIE_ranges.csv")
locus_info <- read.csv("../../data/processed_data/CJ_RefSeq/all_locus_info.csv")

CJIE_list <- CJIE_ranges["accession"]

locus_info_CJIE <- merge(locus_info,CJIE_list,by = "accession", all.y =T)

locus_info_CJIE$type <- "locus"


CJIE_ranges <- CJIE_ranges[c("accession","group","width","start","end","type")]
colnames(CJIE_ranges) <- c("accession","locus_accession","length","start","end","type")

locus_and_CJIE <- rbind(locus_info_CJIE,CJIE_ranges) 

locus_and_CJIE_list <- split(locus_and_CJIE,locus_and_CJIE$accession)


find_locus_location <- function(data) {
  
  locus <- subset(data, type == "locus")
  CJIE <- subset(data, type == "CJIE")
  
  mutiple_CJIE <- split(CJIE,CJIE$locus_accession)
  
  find_location <- function(df,locus) {
      group_num <- df$locus_accession
      target_start <- df$start
      target_end <- df$end
      
      locus$target_start_in_locus <- ifelse(locus$start >= target_start, 1, target_start)
      locus$target_end_in_locus <- ifelse(locus$end >= target_end, locus$length, target_end)
      
      locus$group <- group_num
      return(locus)
  }
    location_on_locus <- lapply(mutiple_CJIE, find_location, locus = locus)
    location_on_locus <- location_on_locus[!sapply(location_on_locus, is.null)]
    
    return(location_on_locus)
}

location_on_locus <- lapply(locus_and_CJIE, find_locus_location)


#
testdata <- locus_and_CJIE_list[[2]]

testCJIE <- subset(CJIE_ranges,accession == "GCF_001717625.1")

target_start <- unique(testCJIE$start)
target_end <- unique(testCJIE$end)

testdata$target_start_in_locus <- ifelse(testdata$start >= target_start, 1, target_start)
testdata$target_end_in_locus <- ifelse(testdata$end >= target_end, testdata$length, target_end)
#


find_locus_location <- function(list) {
  
}





