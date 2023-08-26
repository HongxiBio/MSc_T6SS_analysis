#!/bin/bash
#this script is used to use blast tool to compare CJIE3 sequencces with local_library

conda run -n blast bash -c '

db_path="/home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library/RefSeq_library.fna"

query_path="/home/vader/Documents/MSc-project/data/raw_data/CJIE_RM1221/CJPI_library.fna"

out_path="/home/vader/Documents/MSc-project/Results/CJIE_determining/CJIE_blast_result.csv"

blastn -db "$db_path" -query "$query_path" -outfmt "10 delim=, std qlen slen" -evalue 10 -num_threads 12 -out "$out_path"

'

Rscript /home/vader/Documents/MSc-project/coding/linux_shell_script/CJIE_blast_analysis.R
