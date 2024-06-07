#!/bin/bash

# Set the paths to the scripts
RENAME_SCRIPT="/bobross/sylvester/IFI16_KO_data/20240605/scripts/rename_fastqs.sh" # removes lane number from sample name
#STITCH_FASTQS_SCRIPT="/bobross/sylvester/IFI16_KO_data/20240605/scripts/stitch_fastqs.sh" # put together fastqs from different runs
STAR_LOOP_SCRIPT="/bobross/sylvester/IFI16_KO_data/20240605/scripts/star_loop.sh" # Alignment loop
#RENAME_BAMS_SCRIPT="/bobross/sylvester/IFI16_KO_data/20240605/scripts/rename_bams.sh"
FEATURECOUNTS_SCRIPT="/bobross/sylvester/IFI16_KO_data/20240605/scripts/run_featureCounts_batched.sh" # feature counts batched

# Run the rename_fastqs.sh script  
echo "Running rename_fastqs.sh..."
"$RENAME_SCRIPT"

# Run the stitch_fastqs.sh script # no need
#echo "Running stitch_fastqs.sh..."
#"$STITCH_FASTQS_SCRIPT"

# Run the star_loop.sh script
echo "Running star_loop.sh..."
"$STAR_LOOP_SCRIPT"

# Run the rename bams script
#echo "Running rename_bams.sh..."
#"$RENAME_BAMS_SCRIPT"

# Run the run_featureCounts_batched.sh script
echo "Running run_featureCounts_batched.sh..."
"$FEATURECOUNTS_SCRIPT"
