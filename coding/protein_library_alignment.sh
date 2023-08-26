#!/bin/bash

# Change to the directory where the folders are located
cd /home/vader/Documents/MSc-project/CJ_RefSeq/ncbi_dataset/data

# Create a new text file to store the contents of the selected files
output_file="/home/vader/Documents/MSc-project/CJ_RefSeq/local_database/protein/protienlibrary.faa"
touch "$output_file"

# Loop through all folders that start with "GCF_"
for folder in GCF_*; do
    # Check if the folder is a directory
    if [ -d "$folder" ]; then
        # Change to the folder
        cd "$folder"
        # Loop through all .gff files in the folder
        for file in *.faa; do
            # Check if the file exists (in case there are no .gff files in the folder)
            if [ -e "$file" ]; then
                # Append the file's contents to the output file
                cat "$file" >> "/home/vader/Documents/MSc-project/CJ_RefSeq/local_database/protein/protienlibrary.faa"
            fi
        done
        # Change back to the parent directory
        cd ..
    fi
done

