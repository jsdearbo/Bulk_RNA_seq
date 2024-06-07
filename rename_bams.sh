#!/bin/bash

INPUT_DIR="/bobross/sylvester/IFI16_KO_data/20240605/bam"

# Loop through all files ending with Aligned.sortedByCoord.out.bam
for file in "$INPUT_DIR"/*Aligned.sortedByCoord.out.bam
do
    # Extract the filename without the path
    filename=$(basename "$file")

    # Extract the sample name from the filename
    sample_name=$(echo "$filename" | sed 's/Aligned.sortedByCoord.out.bam$//')

    # Construct the new filename
    new_filename="${sample_name}.bam"

    # Rename the file
    mv "$file" "$INPUT_DIR/$new_filename"
done