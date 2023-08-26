#!/bin/bash

cd /home/vader/Documents/MSc-project/CJ-full-database/ncbi_dataset_sequence_name_modified/data

for folder in */; do
    for file in "$folder"cds_from_genomic.fna; do
        awk -v folder="${folder%/}" '/^>lcl\|/{ sub(/^>lcl\|/,">"folder" ") }1' "$file" > "$file.tmp"
        mv "$file.tmp" "$file"
    done
done

for folder in */; do
    for file in "$folder"cds_from_genomic.fna; do
        awk '/^>/{print $0}' "$file" >> ../cds_info.txt
    done
done
