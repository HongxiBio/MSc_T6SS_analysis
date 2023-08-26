library(dplyr)
library(stringr)


type_group <- read.csv("./protein_function_and_type.csv") 
CJIE_region_info <- read.csv("../../Results/CJIE_determining/potential_CJIE_ranges.csv")
CJIE_region_info$accession <- paste0(CJIE_region_info$accession,"_",CJIE_region_info$group)


folders_link <- file.path()


extract_cds_data <- function(folder_path,CJIE_info) {
  data <- readLines(folder_path)
  
  comment_lines <- grep("^##", data)
  result <- data[(comment_lines[2]+1):(comment_lines[3]-1)]

  df <- str_split_fixed(result, "\t",9)
  df <- data.frame(df)
  colnames(df) <- c("accession","name","tag","start_in_locus","end_in_locus","V6","orientation", "V8", "protein_function")
  df <- df[c("accession","tag","start_in_locus","end_in_locus","orientation","protein_function")]
  df$protein_function <- gsub(".*product=", "", df$protein_function)
  
  data <- left_join(df,type_group,by = "protein_function")
  data$type <- ifelse(is.na(data$type),"other",data$type)
  
  
  accession <- unique(data$accession)
  
  
}



data <- readLines("/home/vader/Documents/MSc-project/data/processed_data/CJIE-3_regions/GCF_001717625.1_1/annotation/PROKKA_08182023.gff")

comment_lines <- grep("^##", data)

result <- data[(comment_lines[2]+1):(comment_lines[3]-1)]

df <- str_split_fixed(result, "\t",9)
df <- data.frame(df)
colnames(df) <- c("accession","name","tag","start_in_locus","end_in_locus","V6","orientation", "V8", "protein_function")

df$protein_function <- gsub(".*product=", "", df$protein_function)

df <- df[c("accession","tag","start_in_locus","end_in_locus","orientation","protein_function")]
df$start_in_locus <- as.numeric(df$start_in_locus)
df$end_in_locus <- as.numeric(df$end_in_locus)

testdata <- left_join(df,type_group,by = "protein_function")

testdata$type <- ifelse(is.na(testdata$type),"other",testdata$type)
testdata$color <- ifelse(is.na(testdata$color), 'yellow', testdata$color)


accession_NUM <- unique(testdata$accession)

CJIE <- subset(CJIE_region_info,subset = accession == accession_NUM, select = c("accession","start","end"))
start_in_genome <- CJIE$start
end_in_genome <- CJIE$end

testdata$start <- testdata$start_in_locus + start_in_genome
testdata$end <- testdata$end_in_locus + start_in_genome

test_feature <- subset(testdata,
                       protein_function != "hypothetical protein" & type != "T6SS_core",
                       select = c("accession","orientation","protein_function","type","start","end"))
test_feature_pos <- subset(test_feature,orientation == "+")
test_feature_neg <- subset(test_feature,orientation =="-")

CJIE_plot <- ggplot(testdata,aes(xmin = start, xmax = end, y = orientation, fill = type, label = type, forward = orientation == "+")) +
  geom_gene_arrow() +
  geom_feature(data = test_feature, aes(x = (start+end)/2, y = orientation)) +
  geom_feature_label(data = test_feature,aes(x = start, y = orientation, label = protein_function)) +
  facet_grid(scales = "free", space = "fixed") +
  scale_fill_manual(values = setNames(testdata$color,testdata$type)) +
  theme_genes()
CJIE_plot

CJIE_plot <- ggplot(testdata,aes(xmin = start, xmax = end, y = orientation, fill = type, label = type, forward = orientation == "+")) +
  geom_gene_arrow() +
  geom_text_repel(data = test_feature,aes(x = (start+end)/2, y = orientation, label = protein_function),
                  direction = "y",
                  force_pull = 0.2,
                  nudge_y = 0.3,
                  max.overlaps = 20,
                  segment.linetype = "dashed",
                  segment.size = 0.1,
                  size = 3) +
  facet_grid(scales = "free", space = "fixed") +
  scale_fill_manual(values = setNames(testdata$color,testdata$type)) +
  theme_genes()+
  xlab("")+
  ylab(unique(testdata$accession))
CJIE_plot

ggsave("../../../MSc-project_test/Results/CJIE_plot_test.png",
       CJIE_plot,
       width = 20, 
       height = 5, 
       device = "png")



example_features
example_dummies

draw_T6SS <- function(df) {
  T6SS_plot <- ggplot(df, aes(xmin = start, xmax = end, y = orientation, fill = sequence_code, label = sequence_code, forward = orientation == "forward")) +
    geom_gene_arrow() +
    geom_gene_label(align = "left") +
    facet_grid(cols = vars(group), scales = "free", space = "fixed") +
    scale_fill_brewer(palette = "Set3",name = "sequence_code") +
    theme_genes()
  return(T6SS_plot)
}

