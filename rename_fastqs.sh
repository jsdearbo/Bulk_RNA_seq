#!/bin/bash

# Set the directory containing the files
INPUT_DIR="/bobross/sylvester/IFI16_KO_data/20240605/fastq"
#INPUT_DIR="/bobross/jdearborn/PIP_seeker/20240605_PIP03_04/PIP03/ADT_fastq"

# Loop through all files ending with _001.fastq.gz
for file in "$INPUT_DIR"/*_001.fastq.gz
do
    ## Extract the filename without the path
    filename=$(basename "$file")

    ## Extract the relevant parts of the filename
    prefix=$(echo "$filename" | cut -d'_' -f1)
    read_number=$(echo "$filename" | cut -d'_' -f3 | cut -c1-2)

    ## Construct the new filename
    new_filename="${prefix}_R${read_number}.fastq.gz"

    #check name
    echo "$new_filename"
    ## Rename the file  
    mv "$file" "$new_filename"
done

gunzip "$INPUT_DIR"/*fastq.gz