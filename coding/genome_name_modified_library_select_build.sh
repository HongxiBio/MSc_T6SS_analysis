#!/bin/bash

# Set the parent directory
parent_dir="/home/vader/Documents/MSc-project/CJ-full-database/ncbi_dataset_sequence_name_modified/data"

# Set the list of folder names
folder_list="/home/vader/Documents/MSc-project/coding/chosen_accession.txt"

# Set the output file
output_file="/home/vader/Documents/MSc-project/CJ-full-database/genome_library/RefSeq_library_name_modified/RefSeq_library.fna"
no_protein_file="/home/vader/Documents/MSc-project/CJ-full-database/genome_library/RefSeq_library_name_modified/no_protein_accessions.txt"
touch "$output_file"
touch "$no_protein_file"

# Loop through each folder name in the list
while read -r folder_name; do
  # Check if the folder exists in the parent directory
  if [[ -d "$parent_dir/$folder_name" ]]; then
    # Find .fna files that start with the father folder's name
    fna_file=$(find "$parent_dir/$folder_name" -type f -name "$folder_name*.fna")
    # Find .faa files
    faa_file=$(find "$parent_dir/$folder_name" -type f -name "*.faa")
    # Check if both files exist
    if [[ -n "$fna_file" && -n "$faa_file" ]]; then
      # Append the .fna file to the output file
      cat "$fna_file" >> "$output_file"
    else
      # Append the folder name to the no_protein_file
      echo "$folder_name" >> "$no_protein_file"
    fi
  fi
done < "$folder_list"

