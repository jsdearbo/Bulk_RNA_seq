#!/bin/bash

# Set the directory containing the files
INPUT_DIR="$1"

# Loop through all files ending with _001.fastq.gz (this is the flow cell number. could also be 002)
for file in "$INPUT_DIR"/*_001.fastq.gz
do
    # Check if the file matches the desired patterns
    if [[ "$file" == *_001.fastq.gz ]] || [[ "$file" == *_001.fastq ]]; then
        # Extract the filename without the path
        filename=$(basename "$file")

        # Extract the relevant parts of the filename
        prefix=$(echo "$filename" | cut -d'_' -f1)
        read_number=$(echo "$filename" | cut -d'_' -f3 | cut -c1-2)

        # Construct the new filename based on the file extension
        extension="${filename##*.}"
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