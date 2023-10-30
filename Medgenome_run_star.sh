#!/bin/bash

# Set the paths to STAR and the reference genome
STAR=/usr/bin/STAR
REF_GENOME=/bobross/STAR_Metadata/mouse/STAR

# Prompt the user for the input directory containing the fastq files
read -p "Enter the global path to the input directory containing the fastq files (for example: '/bobross/jdearborn/RNA_seq/fastq'): " INPUT_DIR

# Set the output directory to "alignment" in the parent directory of $INPUT_DIR
OUTPUT_DIR="$(dirname "$INPUT_DIR")/alignment"

# Set the temporary directory
TMP_DIR="$(dirname "$INPUT_DIR")/alignment/tmp"

# Create the output and temporary directory if it does not exist
mkdir -p "$TMP_DIR"

# Loop over the fastq files in the input directory
for file in "$INPUT_DIR"/*_R1.fastq; do
  # Get the sample name from the file name
  sample=$(basename "$file" _R1.fastq)

  # Set the paths to the read 1 and read 2 files
  r1="$INPUT_DIR/${sample}_R1.fastq"
  r2="$INPUT_DIR/${sample}_R2.fastq"

  printf "Processing sample %s\n" "$sample"

  # Remove the temporary directory if it exists
  if [ -d "$TMP_DIR" ]; then
    rm -r "$TMP_DIR"
  fi

  # Run STAR alignment
  if ! "$STAR" \
    --runThreadN 32 \
    --genomeDir "$REF_GENOME" \
    --readFilesIn "$r1" "$r2" \
    --outFileNamePrefix "$OUTPUT_DIR/${sample}_aligned_reads_" \
    --outSAMtype BAM SortedByCoordinate \
    --outTmpDir "$TMP_DIR"; then
    printf "Error: STAR alignment failed for sample %s\n" "$sample"
    exit 1
  fi
done