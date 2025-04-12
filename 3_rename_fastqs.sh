#!/bin/bash

# Set the directory containing the files
INPUT_DIR="$1"
echo "Input directory: $INPUT_DIR"

# Loop through all files ending with _001.fastq.gz (this is the flow cell number. could also be 002)
for file in "$INPUT_DIR"/*_001.fastq*
do
    # Check if the file matches the desired patterns
    if [[ "$file" == *_001.fastq.gz ]] || [[ "$file" == *_001.fastq ]]; then
        # Extract the filename without the path
        filename=$(basename "$file")

        # Extract the relevant parts of the filename
        prefix=$(echo "$filename" | cut -d'_' -f1)
        read_number=$(echo "$filename" | cut -d'_' -f3 | cut -c1-2)

        # Determine the correct extension
        if [[ "$filename" == *.fastq.gz ]]; then
            extension="fastq.gz"
        elif [[ "$filename" == *.fastq ]]; then
            extension="fastq"
        fi

        # Construct the new filename
        new_filename="$INPUT_DIR/${prefix}_${read_number}.${extension}"

        # Show the new filename for confirmation
        echo "Renaming: $file -> $new_filename"

        # Rename the file
        mv "$file" "$new_filename"
    fi
done

# Use pigz for parallel decompression if available, otherwise fall back to gunzip
if command -v pigz &> /dev/null; then
    pigz -d "$INPUT_DIR"/*fastq.gz
else
    gunzip "$INPUT_DIR"/*fastq.gz
fi