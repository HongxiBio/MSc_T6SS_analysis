#!/bin/bash

conda run -n blast bash -c '

folder_path="/home/vader/Documents/MSc-project/data/processed_data/RefSeq_available_for_analysis"

library_path="/home/vader/Documents/MSc-project/data/processed_data/local_library/RefSeq_library"

for folder in $(ls "$folder_path"); do
    for file in "$folder_path/$folder/mapped_genome.fna"; do
         cat "$file" >> "$library_path/RefSeq_library.fna"
    done
done

makeblastdb -in "$library_path/RefSeq_library.fna" -dbtype nucl -parse_seqids
'

