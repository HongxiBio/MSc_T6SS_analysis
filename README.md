# MSc_T6SS_analysis
This is the repository for automatically analysis T6SS and CJIE-3 region in Campylobacter jejuni
Currently it's only used for storing the codes used in the project. A upgraded pipeline will be updated shortly.

# Appendix script 1: R markdown (.Rmd) for T6SS identification and plot generation
file path: coding/T6SS_determining/T6SS_post_analysis_Rmd.Rmd 

This file will output:
  1.the hit table for each identified T6SS positive genome.
  2.metadata for T6SS positive genomes
  3.accession list of T6SS positive genomes
  4.plots of T6SS' architecture with no more than 3 loci
  5.T6SS cluster position in genome
  
# Appendix script 2: R markdown (.Rmd) for CJIE-3 identification with the 3 key genes
file path: coding/CJIE_determining/CJIE_genes_post_analysis.Rmd

This file will output:
  1. Hit table for the 3 key genes in all machted genomes
  2. CJIE-3 positive genome with metadata
  3. simpler version of the hit table
note: this script analysed not only CJIE-3 but also potential plasmids. For better interpretation in report, the plasmid+ was classified into CJIE-3 negative.

# Appendix script 3: R markdown (.Rmd) for locating potenital CJIE-3 regions and identify the regions with any 3 key genes 
file path: coding/CJIE_determining/CJIE_post_blast_analysis_2.Rmd

This file will output:
  1. potential CJIE-3 regions for each matches genomes
  2. identified CJIE-3 regions with accession number, location and size

# Appendix script 4: R markdown (.Rmd) for analysing CJIE-3 regions generating plots for every identified CJIE-3 regions 
file path: coding/CJIE_determining/select_CJIE_covered_locus.Rmd

This file will output:
  1. identified CJIE-3 regions with position in genome, size, acctual sequence and GC-content
  2. annotated by extenral application (prokka)
  3. plots for every identified CJIE-3 regions
