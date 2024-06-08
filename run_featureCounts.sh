#!/bin/bash

# Define the path to the folder containing the BAM files
bam_folder="/bobross/sylvester/IFI16_KO_data/20240605/" 
treatment="OC43"


# Define the path to the GTF file (gene annotation file)
#gtf_file="/bobross/STAR_Metadata/mouse/gencode.vM30.annotation.gtf"  # for mouse
gtf_file="/bobross/STAR_Metadata/human/gencode.v46.primary_assembly.annotation.gtf"   # for human (basic annotation)

# Define the path to the output folder for count matrices
output_folder="/bobross/sylvester/IFI16_KO_data/Feature_Counts/batched"

# Make sure the output folder exists (create it, if not)
mkdir -p "$output_folder"


  # Run featureCounts to get gene counts data for this sample
  featureCounts \
    -T 32\
    -Q 30 \
    -a "$gtf_file" \
    -o "$output_folder/${treatment}_counts.txt" \
    $bam_folder/*.bam

# Note that this will generate a single counts matrix for all samples. each sample will have it's own count column

