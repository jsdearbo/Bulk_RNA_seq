#!/bin/bash

# change to fastq directory
#cd /bobross/jdearborn/PIP_seeker/20240328_PIP01/fastq

# loop through all fastq files and run FastQC
for file in *.fastq.gz; do 
	fastqc "$file"
done 
