#!/bin/bash

# Change to the directory where the folders are located
cd /home/vader/Documents/MSc-project/CJ-full-database/ncbi_dataset/data

# Create a new text file to store the contents of the selected files
librarySeq="librearySeq.fna"
touch "$librarySeq"

# Loop through all folders that start with "GCF_"
for folder in GC*; do
    # Check if the folder is a directory

        # Change to the folder
        cd "$folder"
        # Loop through all files in the folder
        for file in *; do
            # Check if the file starts with the folder's name
            if [[ $file == $folder* ]]; then
                # Append the file's contents to the output file
                cat "$file" >> "/home/vader/Documents/MSc-project/CJ-full-database/genome_library/$librarySeq"
            fi
        done
        # Change back to the parent directory
        cd ..

done
