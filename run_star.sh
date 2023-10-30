#!/bin/bash

# Set the paths to STAR and the reference genome
STAR=/usr/bin/STAR
REF_GENOME=/bobross/STAR_Metadata/mouse/STAR

# Set the input directory containing the fastq files
INPUT_DIR=/bobross/jdearborn/analysis/in_vitro_dep_2/data/fastq
#INPUT_DIR=./data

# Set the output directory
OUTPUT_DIR=/bobross/jdearborn/analysis/in_vitro_dep_2/data/alignment

# Set the temporary directory
TMP_DIR=/bobross/jdearborn/analysis/in_vitro_dep_2/data/tmp

# Loop over the fastq files in the input directory
for file in $INPUT_DIR/*_R1.fastq; do
  # Get the sample name from the file name
  sample=$(basename "$file" _R1.fastq)

  # Set the paths to the read 1 and read 2 files
  r1="$INPUT_DIR/${sample}_R1.fastq"
  r2="$INPUT_DIR/${sample}_R2.fastq"

  # Remove the temporary directory if it exists
  if [ -d "$TMP_DIR" ]; then
    rm -r "$TMP_DIR"
  fi

  # Run STAR alignment
  $STAR \
    --runThreadN 32 \
    --genomeDir $REF_GENOME \
    --readFilesIn $r1 $r2 \
    --outFileNamePrefix $OUTPUT_DIR/${sample}_aligned_reads_ \
    --outSAMtype BAM SortedByCoordinate \
    --outTmpDir $TMP_DIR
done