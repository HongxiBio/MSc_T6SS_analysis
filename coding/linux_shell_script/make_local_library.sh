#!/bin/bash

#this script is used to attache all genome sequences into one file and make database

conda run -n blast bash -c '

source_folder="/home/vader/Documents/MSc-project/data/processed_data/CJ_RefSeq/ncbi_dataset/data"
target_folder="/home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library"
library_file="$target_folder/RefSeq_library.fna"

# check and create the output folder
if [ ! -d "$target_folder" ]; then
  mkdir -p "$target_folder"
fi

# clear output file RefSeq_library.txt
> "$library_file"

# check all files that start with "GCF" and end with ".fna", and paste into output files

find "$source_folder" -type f -name "GCF*.fna" -exec cat {} >> "$library_file" \;

echo "files have been copied in to library"

makeblastdb -in "$library_file" -dbtype nucl -parse_seqids
'
