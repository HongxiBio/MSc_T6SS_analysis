#!/bin/bash
#this script is used to use blast tool to compare T6SS sequencces with local_library

conda run -n blast bash -c '

db_path="/home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library/RefSeq_library.fna"

query_path="/home/vader/Documents/MSc-project/data/raw_data/T6SS_protein_reference/T6SS-protein.fasta"

out_path="/home/vader/Documents/MSc-project/Results/T6SS_identification/T6SS_blast_result.csv"

tblastn -db "$db_path" -query "$query_path" -outfmt "10 delim=, std qlen slen" -evalue 10 -num_threads 12 -out "$out_path"

'

Rscript /home/vader/Documents/MSc-project/coding/linux_shell_script/T6SS_blast_analysis.R
