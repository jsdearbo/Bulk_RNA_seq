#!/bin/bash

# Change to the directory containing the FASTQ files
cd /bobross/jdearborn/analysis/RNA_seq/data

# Loop through all FASTQ files and run FastQC
for file in *.fastq; do
    fastqc "$file"
done

