#!/bin/bash

# Set the input and output directories
input_dir1="/bobross/sylvester/IFI16_KO_data/poly_ic_treatment/fastq/"
input_dir2="/bobross/sylvester/IFI16_KO_data/poly_ic_treatment/fastq/rerun/"
output_dir="/bobross/sylvester/IFI16_KO_data/poly_ic_treatment/fastq/concat/"

# Create the output directory if it doesn't exist
mkdir -p $output_dir

# Read 1: Loop through files ending with *R1.fastq.gz in input_dir2
for file2 in "$input_dir2"/*R1.fastq.gz
do
    # Get the base filename (first 7 characters)
    filename="${file2##*/}"
    base_name="${filename:0:6}"

    # Find the corresponding file in input_dir1
    file1="$input_dir1/$base_name"*R1.fastq.gz

    # Desigante output file
    output_file="$output_dir/${base_name}_R1.fastq"

    # Check if the output file already exists, concatenate and gunzip if not
    if [ ! -f "$output_file" ]; then
        cat $file1 $file2 > "${output_file}.gz"
        gunzip "${output_file}.gz"
    else
        echo "Skipping $base_name as it already exists."
    fi

    # Uncomment the following lines for debugging
    # echo $filename
    # echo $base_name
    # echo $file1
    # echo $file2
    # echo "${output_file}.gz"
done

# Read 2: Loop through files ending with *R2.fastq.gz in input_dir2
for file2 in "$input_dir2"/*R2.fastq.gz
do
    # Get the base filename (first 7 characters)
    filename="${file2##*/}"
    base_name="${filename:0:6}"

    # Find the corresponding file in input_dir1
    file1="$input_dir1/$base_name"*R2.fastq.gz

    # Concatenate the files and write (uncompressed) to output_dir
    output_file="$output_dir/${base_name}_R2.fastq"

    # Check if the output file already exists
    if [ ! -f "$output_file" ]; then
        cat $file1 $file2 > "${output_file}.gz"
        gunzip "${output_file}.gz"
    else
        echo "Skipping $base_name as it already exists."
    fi

    # Uncomment the following lines for debugging
    # echo $filename
    # echo $base_name
    # echo $file1
    # echo $file2
    # echo $output_file
done