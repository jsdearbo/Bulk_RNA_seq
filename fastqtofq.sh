#!/bin/bash

# Loop through all files in the directory with .fq extension
for f in *.fastq
do
  # Use the mv command to rename the file with .fastq extension
  mv "$f" "${f%.fastq}.fq"
done
