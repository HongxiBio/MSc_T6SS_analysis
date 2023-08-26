
#!/bin/bash

# set file paths 
source_folder="/home/vader/Documents/MSc-project/data/raw_data/CJ-full-database/ncbi_dataset/data"
destination_folder="/home/vader/Documents/MSc-project/data/processed_data/RefSeq_available_for_analysis"
txt_file="/home/vader/Documents/MSc-project/coding/linux_shell_script/chosen_accession.txt"

# enter_source_folder_path
cd "$source_folder" || exit

# use while to loop read subfolder's name
while IFS= read -r subfolder_name
do
    # check the existance of subfolders
    if [ -d "$subfolder_name" ]; then
        cp -r "$subfolder_name" "$destination_folder"
        echo "copy '$subfolder_name' to data/processed_data/RefSeq_available_for_analysis"
    else
        echo "warning: '$subfolder_name' is not exist, skip copy"
    fi
done < "$txt_file"

