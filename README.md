# Scripts for MSc T6SS bioinformatic analysis
This is the repository for automatically analysis T6SS and CJIE-3 region in *Campylobacter jejuni*
Currently it's only used for storing the codes used in the project. A upgraded pipeline will be updated shortly.

## Appendix 8: R markdown (.Rmd) for T6SS identification and plot generation
file path: coding/T6SS_determining/T6SS_post_analysis_Rmd.Rmd 

This file will output:
  1. the hit table for each identified T6SS positive genome 
  2. metadata for T6SS positive genomes 
  3. accession list of T6SS positive genomes 
  4. plots of T6SS' architecture with no more than 3 loci
  5. T6SS cluster position in genome
  
## Appendix 9: R markdown (.Rmd) for CJIE-3 identification with the 3 key genes
file path: coding/CJIE_determining/CJIE_genes_post_analysis.Rmd

This file will output:
  1. Hit table for the 3 key genes in all machted genomes
  2. CJIE-3 positive genome with metadata
  3. simpler version of the hit table

note: this script analysed not only CJIE-3 but also potential plasmids. For better interpretation in report, the plasmid+ was classified into CJIE-3 negative.

## Appendix 10: R markdown (.Rmd) for locating potenital CJIE-3 regions and identify the regions with any 3 key genes 
file path: coding/CJIE_determining/CJIE_post_blast_analysis_2.Rmd

This file will output:
  1. potential CJIE-3 regions for each matches genomes
  2. identified CJIE-3 regions with accession number, location and size

## Appendix 11: R markdown (.Rmd) for analysing CJIE-3 regions and output them as .fna file for annotation 
file path: coding/CJIE_determining/select_CJIE_covered_locus.Rmd

This file will output:
  1. identified CJIE-3 regions with position in genome, size, acctual sequence and GC-content
  2. CJIE-3 sequences in .fna file

## Appendix 12: R markdown (.Rmd) for generating plots for CJIE-3 
file path: coding/graph_generation/generate_the_graph.Rmd

This file will outut:
  1. CJIE-3 plots with respective accession number 

## Appendix 13: R markdown (.Rmd) for summarize the proportion of T6SS and CJIE-3 
File path: coding/summary_analysis/merged_analysis_for_CJIE_and_T6SS.Rmd

This file will output:
  1. frequency table for T6SS and CJIE-3 in whole gnoemes (n=725)
  2. frequency table for T6SS and CJIE-3 in complete genome datasets (n=286)

## Appendix 14: Linux shell scripts used in this analysis
File path: coding/linux_shell_script

This folder includes every linux scirpts I used in this porject, including genome downloading, metadata collection, BLASTn, tBLASTp, prokka analysis

## Appendix 15: Rmd for selecting locus information
File path: coding/CJIE_determining/locus_information_selection.R

This file will output:
  1. every loci information with accession, length, position and names.
  
