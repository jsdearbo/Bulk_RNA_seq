#!/bin/bash

# Carry in user input variables. 
# This is necessary to run the whole pipeline via a nested nohup call.
RUN_QC="$1"
GENOME="$2"
EXPERIMENT_DIR="$3"
LOG_DIR="$4"
INPUT_DIR="$5"

# Set the paths to the scripts
RENAME_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/3_rename_fastqs.sh" # removes lane number from sample name
FASTQC_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/4_run_fastqc.sh" # QC assessment
STAR_LOOP_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/5_star_loop.sh" # Alignment loop
FEATURECOUNTS_SCRIPT="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/6_run_featureCounts_batched.sh" # feature counts batched

# Set log paths (integrate this?)
RENAME_LOG="$LOG_DIR/rename_fastqs.log"
FASTQC_LOG="$LOG_DIR/run_fastqc.log"
STAR_LOG="$LOG_DIR/star_loop.log"
FEATURECOUNTS_LOG="$LOG_DIR/run_featureCounts.log"

touch "$RENAME_LOG"

# Run the rename_fastqs.sh script. Also used for decompression of .gz files
echo "Running rename_fastqs.sh..."
nohup bash "$RENAME_SCRIPT" "$INPUT_DIR" > "$RENAME_LOG" 2>&1
echo "rename_fastqs.sh completed."

# Run FastQC
if [ "$RUN_QC" = "yes" ]; then
    echo "Running run_fastqc.sh..."
    nohup bash "$FASTQC_SCRIPT" "$INPUT_DIR" > "$FASTQC_LOG" 2>&1
    echo "run_fastqc.sh completed."
else
    echo "Skipping FastQC run."
fi

# Run the star_loop.sh script
echo "Running star_loop.sh..."
nohup bash "$STAR_LOOP_SCRIPT" "$EXPERIMENT_DIR" "$GENOME" "$INPUT_DIR" > "$STAR_LOG" 2>&1
echo "star_loop.sh completed."

# Run the run_featureCounts_batched.sh script
echo "Running run_featureCounts_batched.sh..."
nohup bash "$FEATURECOUNTS_SCRIPT" "$EXPERIMENT_DIR" "$GENOME" > "$FEATURECOUNTS_LOG" 2>&1
echo "run_featureCounts_batched.sh completed."

