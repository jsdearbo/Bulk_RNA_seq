#!/bin/bash

# Set the paths to STAR and the reference genome
STAR=/usr/bin/STAR
REF_GENOME=/bobross/STAR_Metadata/human/STAR

# Set directories
INPUT_DIR="/bobross/sylvester/IFI16_KO_data/20240605/fastq" # input fastq files
OUTPUT_DIR="/bobross/sylvester/IFI16_KO_data/20240605/bam" # output bam files
STAR_LOG_DIR="/bobross/sylvester/IFI16_KO_data/20240605/star_logs" # STAR log output files

# Create the output and STAR logs directories if they don't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$STAR_LOG_DIR"

# Loop over the fastq files in the input directory
for file in "$INPUT_DIR"/*_R1.fastq; do
  # Get the sample name from the file name
  sample=$(basename "$file" _R1.fastq)

  # Set the paths to the read 1 and read 2 files
  r1="$INPUT_DIR/${sample}_R1.fastq"
  r2="$INPUT_DIR/${sample}_R2.fastq"

  # Check if the input files exist
  if [ ! -f "$r1" ] || [ ! -f "$r2" ]; then
    echo "Error: Input files not found for sample $sample"
    continue
  fi

  echo "r1: $r1"
  echo "r2: $r2"
  echo "sample: $sample"

  # Run STAR alignment
  if [ ! -f "$OUTPUT_DIR/$sample"* ]; then
    $STAR \
      --runThreadN 16 \
      --genomeDir "$REF_GENOME" \
      --readFilesIn "$r1" "$r2" \
      --outFileNamePrefix "$OUTPUT_DIR/$sample" \
      --outSAMtype BAM SortedByCoordinate \

  else
    echo "Skipping $sample as an alignment already exists in the output directory."
  fi

  # Check the exit status of STAR and handle errors if needed
  if [ $? -ne 0 ]; then
    echo "Error: STAR alignment failed for sample $sample"
    # Add additional error handling code here if needed
  fi

  # Simplify output bam filenames
  mv "$OUTPUT_DIR/${sample}"Aligned.sortedByCoord.out.bam "$OUTPUT_DIR/${sample}.bam"
  # Move all files with '.out' or '.tab' extensions to the STAR log directory
  mv "$OUTPUT_DIR"/*.out "$OUTPUT_DIR"/*.tab "$STAR_LOG_DIR"

done