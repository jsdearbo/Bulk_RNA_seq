#!/bin/bash

# Set the paths to STAR and the reference genome
STAR=/usr/bin/STAR
MAX_LOAD=16.0  # Maximum system load allowed to start the script

# Check if STAR exists
if [ ! -x "$STAR" ]; then
  echo "Error: STAR executable not found at $STAR. Please check the path."
  exit 1
fi

# Set Reference genome based on species input from pipeline.sh
if [ "$2" = "mouse" ]; then
  REF_GENOME="/bobross/STAR_Metadata/mouse/STAR"
elif [ "$2" = "human" ]; then
  REF_GENOME="/bobross/STAR_Metadata/human/STAR"
else
  echo "Error: No reference genome set. Please specify 'mouse' or 'human' as the second argument."
  exit 1
fi

echo "Reference Genome Path: $REF_GENOME"

# Set directories
INPUT_DIR="$1/fastq"
OUTPUT_DIR="$1/bam"        # Output BAM files
STAR_LOG_DIR="$1/star_logs" # STAR log output files

# Create the output and STAR logs directories if they don't exist
mkdir -p "$OUTPUT_DIR" "$STAR_LOG_DIR"

# Function to get the current system load (1-minute average)
get_current_load() {
  # Extract the first value from /proc/loadavg which represents the 1-minute load average
  awk '{print $1}' /proc/loadavg
}

# Wait until the system load is below the maximum allowed load
while true; do
  current_load=$(get_current_load)
  
  # Compare current load with the maximum load
  if (( $(echo "$current_load < $MAX_LOAD" | bc -l) )); then
    echo "System load ($current_load) is under the threshold ($MAX_LOAD). Proceeding..."
    
    # Loop over the fastq files in the input directory
    for file in "$INPUT_DIR"/*_R1.fastq; do
      # Get the sample name from the file name
      sample=$(basename "$file" _R1.fastq)

      # Set the paths to the read 1 and read 2 files
      r1="$INPUT_DIR/${sample}_R1.fastq"
      r2="$INPUT_DIR/${sample}_R2.fastq"
      output_bam="$OUTPUT_DIR/${sample}.bam"

      # Check if the input files exist
      if [ ! -f "$r1" ] || [ ! -f "$r2" ]; then
        echo "Error: Input files not found for sample $sample"
        continue
      fi

      echo "Processing sample: $sample"
      echo "Read 1: $r1"
      echo "Read 2: $r2"

      # Run STAR alignment if output BAM file does not already exist
      if [ ! -f "$output_bam" ]; then
        $STAR \
          --runThreadN 24 \
          --genomeDir "$REF_GENOME" \
          --readFilesIn "$r1" "$r2" \
          --outFileNamePrefix "$OUTPUT_DIR/$sample" \
          --outSAMtype BAM SortedByCoordinate

        # Check if STAR ran successfully
        if [ $? -ne 0 ]; then
          echo "Error: STAR alignment failed for sample $sample"
          continue
        fi

        # Rename output BAM to simplify filename
        mv "$OUTPUT_DIR/${sample}Aligned.sortedByCoord.out.bam" "$output_bam"
      else
        echo "Skipping $sample as an alignment already exists in the output directory."
      fi

      # Move STAR output logs to the STAR log directory
      mv "$OUTPUT_DIR/${sample}"*.out "$OUTPUT_DIR/${sample}"*.tab "$STAR_LOG_DIR" 2>/dev/null
    done
    break
  else
    echo "System load ($current_load) is above the threshold ($MAX_LOAD). Waiting..."
    sleep 60  # Wait before checking the load again
  fi
done
