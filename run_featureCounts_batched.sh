#!/bin/bash

# Set directories
bam_folder="$1/bam"  
output_folder="$1/feature_counts/batched" # counts files output directory
summary_folder="$output_folder/summaries"

# Set Reference annotation file based on species input from pipeline.sh
if [ "$2" = "mouse" ]; then
  gtf_file=/bobross/STAR_Metadata/mouse/gencode.vM30.annotation.gtf
elif [ "$2" = "human" ]; then
  gtf_file=/bobross/STAR_Metadata/human/gencode.v46.primary_assembly.annotation.gtf
else
  echo "No reference genome set"
fi

echo "Reference Genome Path: $REF_GENOME"

# Make sure the output folders exist (create, if not)
mkdir -p "$output_folder"
mkdir -p "$summary_folder"

# Debugging: Check if BAM files are found
echo "Looking for BAM files in $bam_folder"
bam_files=("$bam_folder"/*.bam)
if [ -z "${bam_files[0]}" ]; then
  echo "No BAM files found in $bam_folder"
  exit 1
else
  echo "Found BAM files:"
  for bam_file in "${bam_files[@]}"; do
    echo "$(basename "$bam_file")"
  done
fi

# Debugging: List BAM files with full paths
echo "BAM files with full paths:"
for bam_file in "${bam_files[@]}"; do
  echo "$bam_file"
done

# Run featureCounts to get gene counts data for this sample  # -p flag for paired end reads
featureCounts \
  -T 32 \
  -Q 30 \
  -p \
  -a "$gtf_file" \
  -o "$output_folder/all_sample_counts.txt" \
  "${bam_files[@]}"
  
# Note that this will generate a single counts matrix for all samples. each sample will have it's own count column

# move summary files
mv "$output_folder"/*.summary "$summary_folder"