#!/bin/bash

cd /home/vader/Documents/MSc-project/CJ-full-database/ncbi_dataset_sequence_name_modified/data/

for folder in */; do
    for file in "$folder"*.fna; do
        awk -v folder="$folder" '/^>/{ $0=">"folder"."++i }1' "$file" > "$file.tmp"
        mv "$file.tmp" "$file"
    done
done
