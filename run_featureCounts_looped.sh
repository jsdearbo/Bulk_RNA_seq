#!/bin/bash

# Set directories
bam_folder="/bobross/sylvester/IFI16_KO_data/oc43_infection/bam/rerun"  # OC43 infection input bams
# bam_folder="/bobross/sylvester/IFI16_KO_data/poly_ic_treatment"  # PolyIC stimulation input bams
output_folder="/bobross/sylvester/IFI16_KO_data/oc43_infection/feature_counts/rerun/individual" # counts files output directory
summary_folder="/bobross/sylvester/IFI16_KO_data/oc43_infection/feature_counts/rerun/summaries"

# Set input annotation file
# gtf_file="/bobross/STAR_Metadata/mouse/gencode.vM30.annotation.gtf"  # for mouse
gtf_file="/bobross/STAR_Metadata/human/gencode.v46.primary_assembly.annotation.gtf"   # for human (basic annotation)

# Make sure the output folders exist (create, if not)
mkdir -p "$output_folder"
mkdir -p "$summary_folder"

# Loop through each BAM file in the bam_folder directory
for bam_file in "$bam_folder"/*.bam; do
    # Extract the base name of the BAM file (without the .bam extension)
    base_name="${bam_file##*/}"
    output_name="${base_name:0:7}"
    
    # Define the output file path for this BAM file
    output_file="$output_folder/${output_name}_counts.txt"

    # Run featureCounts for this BAM file
    featureCounts \
        -T 32 \
        -Q 30 \
        -a "$gtf_file" \
        -o "$output_file" \
        "$bam_file"

    echo "Counts generated for $output_name and saved to $output_file"
done