#!/bin/bash

cd /home/vader/Documents/MSc-project/data/processed_data/CJ_RefSeq/ncbi_dataset/data

for folder in */; do
    for file in "$folder"cds_from_genomic.fna; do
        awk -v folder="${folder%/}" '/^>lcl\|/{ sub(/^>lcl\|/,">"folder"|") }1' "$file" > "$file.tmp"
        mv "$file.tmp" "$file"
    done
done
