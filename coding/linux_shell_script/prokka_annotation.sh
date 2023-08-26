#!/bin/bash

conda run -n annotation bash -c '

# change work direction
cd /home/vader/Documents/MSc-project/data/processed_data/CJIE-3_regions

# loop for all folders
for dir in */
do
    cd $dir

    # if file CJIE-3.fna exists, annotate it with prokka
    if [ -f "CJIE-3.fna" ]
    then
        prokka CJIE-3.fna --quiet --outdir annotation --force --proteins /home/vader/Documents/MSc-project/data/raw_data/488/genome/488_for_annotation.gbk --cpus 12
    fi

    # back to upper folder
    cd ..
done
'

