#!/bin/bash

cd /home/vader/Documents/MSc-project/data/processed_data/RefSeq_available_for_analysis
touch /home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library/RefSeq_library.fna

for folder in */; do
    for file in "$folder"GCF*.fna; do
         awk -v folder="${folder%/}" '/^>/{ $0 = $0 " " folder }1' "$file" >> /home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library/RefSeq_library.fna
    done
done

conda run -n blast bash -c '

# set the path
cd /home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library

# generate library by makeblastdb
makeblastdb -in RefSeq_library.fna -dbtype nucl -parse_seqids'
