

#!/bin/bash


# load enviornment blast

conda run -n blast bash -c '


# set the path

data_folder="/home/vader/Documents/MSc-project/data/processed_data/RefSeq_available_for_analysis"


# function to process a subfolder

process_subfolder() {

    folder="$1"

    gcf_file=$(find "$folder" -maxdepth 1 -type f -name "mapped_genome.fna")


    if [ -n "$gcf_file" ]; then

        blastn -db /home/vader/Documents/MSc-project/data/processed_data/local_library/nctc11168_library/GCF_000009085.1_ASM908v1_genomic.fna -query "$gcf_file" -outfmt "10 delim=, std qlen slen" -evalue 10 -out "$folder/blast_result.csv"

    else

        echo "no GCF files in folder $folder"

    fi

}


# export the function to make it available to GNU Parallel

export -f process_subfolder


# get all subfolders in target folder

subfolders=$(find "$data_folder" -mindepth 1 -maxdepth 1 -type d)


# run the process_subfolder function in parallel for each subfolder

echo "$subfolders" | parallel -j 12 process_subfolder

'
Rscript /home/vader/Documents/MSc-project/coding/linux_shell_script/individual_blast_post_analysis.R

