#!/bin/bash

# FastqQC will run faster on decompressed files.
# The program will decompress .gz files on-th-fly.

# Set Input Directory
INPUT_DIR="$1/fastq" # provided by pipeline.sh

# Create and set an outut directory
OUTPUT_DIR="$INPUT_DIR/fastqc_output"
mkdir -p "$OUTPUT_DIR"

# loop through all fastq files and run FastQC
# Create and set an output directory
OUTPUT_DIR="$INPUT_DIR/fastqc_output"
mkdir -p "$OUTPUT_DIR"

# Loop through all fastq files and run FastQC
for file in "$INPUT_DIR"/*.fastq; do
    # Get the basename of the fastq file
    filename=$(basename "$file")
    prefix="${filename%.*}"

    # Check if output files already exist
    if [ ! -f "$OUTPUT_DIR/$prefix"_fastqc.html ] || [ ! -f "$OUTPUT_DIR/$prefix"_fastqc.zip ]; then
        # Run FastQC if output files don't exist
        fastqc -o "$OUTPUT_DIR" "$file"
    else
        echo "Output files already exist for $file"
    fi
done

echo "INPUT_DIR: $INPUT_DIR"
echo "OUTPUT_DIR: $OUTPUT_DIR"
