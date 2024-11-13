#!/bin/bash

# ensure that you have a folder with your experiment name
# within that folder must be a fastq folder that contains your gz compressed fastq files

# Set the directory containing the files. starts w/gz files
echo "Please enter the directory path to the fastq directory within your dedicated experiment directory:"
read -e -p "directory path: " file_path

PIPELINE_LAUNCH="/bobross/jdearborn/shell_scripts/Bulk_RNA_seq/pipeline/2_run_pipeline.sh"

# Check if the provided path ends with /fastq, if not, create a fastq directory and move the files
if [[ ! "$file_path" =~ /fastq$ ]]; then
    mkdir -p "$file_path/fastq"
    mv "$file_path"/*fastq "$file_path/fastq"
    file_path_fastq="$file_path/fastq"
else
    file_path_fastq="$file_path"
fi

# Check if the provided path is a directory
if [ -d "$file_path_fastq" ]; then
    echo "The directory path is: $file_path_fastq"
    INPUT_DIR="$file_path_fastq" #use for rename, fastqc
    EXPERIMENT_DIR=$(dirname "$file_path_fastq")  # pass this to scripts
    echo "EXPERIMENT_DIR: $EXPERIMENT_DIR"
    
    # Prompt the user to enter a species for alignment and feature counts
    while true; do
        echo "Alignment to mouse or human genome?"
        read -e -p "Type m or h and press enter: " species

        case "$species" in
            m|M)
                GENOME="mouse"
                break
                ;;
            h|H)
                GENOME="human"
                break
                ;;
            *)
                echo "Invalid input. Please try again."
                ;;
        esac
    done
    echo "Genome selected: $GENOME"

    # Prompt the user to run fastqc or not
    while true; do
        echo "Do you want to run FastQC on your FASTQ files? (adds ~10 min/file)"
        read -e -p "Type y or n and press enter: " QC_CHECK

        case "$QC_CHECK" in
            y|Y)
                RUN_QC="yes"
                break
                ;;
            n|N)
                RUN_QC="no"
                break
                ;;
            *)
                echo "Invalid input. Please type 'y' or 'n'."
                ;;
        esac
    done
    # Set and create a logs directories
    LOG_DIR="$EXPERIMENT_DIR/pipeline_logs"
    mkdir -p "$LOG_DIR"

    # Run the pipeline function with nohup
    nohup bash "$PIPELINE_LAUNCH" "$RUN_QC" "$GENOME" "$EXPERIMENT_DIR" "$LOG_DIR" "$INPUT_DIR" > "$LOG_DIR/pipeline.log" 2>&1 
    #nohup bash -c '. "./run_pipeline.sh"; run_pipeline "$RUN_QC" "$GENOME" "$EXPERIMENT_DIR"' > "$LOG_DIR/pipeline.log" 2>&1 &
else
    echo "Error: The provided path is not a valid directory."
    exit 1
fi


# improvements to the pipeline:
# file finder outputs for logs as with featurecounts
    # this is a nice feature
# -sequencing vendor specifics, we're set up for OMRF nomanclature here
    #fastq or fq accommadation
# -option to run featurecounts batched or looped (low priority)
# -add an automated call to gzip input fastqs. this will need to be carefully implemented as it must check completion first.
    # -frankly not sure if this is in the cards
# -add prompts for user input component selections: do yo want to run fastqc?
# use runuser for pipeline/script launches
    # I'll need to get the username somehow.
    # runuser -l username -c 'nohup script.sh > logfile.txt 2>&1'
    ## Get the username of the user who launched the script
    # username=$(whoami)
    # runuser -l $username -c 'nohup script.sh > logfile.txt 2>&1'

