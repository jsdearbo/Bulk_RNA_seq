#!/bin/bash

# Define the path to the folder containing the BAM files
bam_folder="/bobross/jdearborn/analysis/RNA_seq/data/bams"

# Define the path to the GTF file (gene annotation file)
gtf_file="/bobross/STAR_Metadata/mouse/gencode.vM30.annotation.gtf"

# Define the path to the output folder for count matrices
output_folder="/bobross/jdearborn/analysis/RNA_seq/data/Feature_Counts"

# Make sure the output folder exists
mkdir -p "$output_folder"


  # Run featureCounts to get gene counts data for this sample
  featureCounts \
    -T 32\
    -Q 30 \
    -a "$gtf_file" \
    -o "$output_folder/counts.txt" \
    /bobross/jdearborn/analysis/RNA_seq/data/bams/*.bam

