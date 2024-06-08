#!/bin/bash

# ensure that you have a folder with your experiment name
# within that folder must be a fastq folder that contains your gz compressed fastq files
    # possible update: nest in an if loop fastq or fastq gz compatabliity
# Set the directory containing the files. starts w/gz files

echo "Please enter the directory path to the fastq folder within your dedicated experiment folder:"
read -e -p "directory path: " file_path

if [ -d "$file_path" ]; then
    echo "The directory path is: $file_path"
    # Perform operations with the directory path
else
    echo "Error: The provided path is not a valid directory."
    exit 1
fi

INPUT_DIR="$file_path" #use for rename, fastqc
EXPERIMENT_DIR=$(dirname "$file_path")  # pass this to scripts
echo "EXPERIMENT_DIR: $EXPERIMENT_DIR"

# Prompt the user to enter a species for alignment and feature counts
while true; do
    echo "Alignment to mouse or human genome?"
    read -e -p "Type m or h and press enter: " species

    case "$species" in
        m)
            GENOME="mouse"
            break
            ;;
        h)
            GENOME="human"
            break
            ;;
        *)
            echo "Invalid input. Please try again."
            ;;
    esac
done

echo "Genome selected: $GENOME"

# Set the paths to the scripts
RENAME_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/rename_fastqs.sh" # removes lane number from sample name
FASTQC_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/run_fastqc.sh" # QC assessment
STAR_LOOP_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/star_loop.sh" # Alignment loop
FEATURECOUNTS_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/run_featureCounts_batched.sh" # feature counts batched

# START CALLING SCRIPTS
# Run the rename_fastqs.sh script. Also used for decompression .gz files
echo "Running rename_fastqs.sh..."
bash "$RENAME_SCRIPT" "$EXPERIMENT_DIR"

# Run FastQC
echo "Running run_fastqc.sh..."
"$FASTQC_SCRIPT" "$EXPERIMENT_DIR"

# # Run the star_loop.sh script
echo "Running star_loop.sh..."
"$STAR_LOOP_SCRIPT" "$EXPERIMENT_DIR" "$GENOME"

# Run the run_featureCounts_batched.sh script
echo "Running run_featureCounts_batched.sh..."
"$FEATURECOUNTS_SCRIPT" "$EXPERIMENT_DIR" "$GENOME"


# improvements to the pipeline:
# -prompt species for alignment/annotation
    # -encode the input of this prompt to a file path for star/featurecounts references
    # -pass this as a 2nd argument to star and feature counts script calls
# -fastqc y/n and other software prompts
# -sequencing vendor specifics, we're set up for OMRF nomanclature here
# -option to run featurecounts batched or looped (low priority)
# -add an automated call to gzip input fastqs. this will need to be carefully implemented as it must check completion first.
    # -frankly not sure if this is in the cards
# -add prompts for user input component selections: do yo want to run fastqc?