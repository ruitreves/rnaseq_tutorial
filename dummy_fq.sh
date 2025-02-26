#!/bin/bash

# make new fastq directory 

mkdir fastq

# then lets see all the files in the directory 

for fq in /Users/hardestylab4/Desktop/FAM20C_chronic_liver_rnaseq_012725/fastq/*; do
    echo $fq
done


# trim off the file path and append "demo" to the front to differentiate between originals and the demos 

for fq in /Users/hardestylab4/Desktop/FAM20C_chronic_liver_rnaseq_012725/fastq/*; do
    newname="demo"_$(basename $fq)
    echo $newname
done

# notice that all the original files are gzipped. we dont want the resulting files to be gzipped since they are already so small

# create the demo files using the head command

for fq in /Users/hardestylab4/Desktop/FAM20C_chronic_liver_rnaseq_012725/fastq/*; do
    newname="demo"_$(basename $fq .gz)
    gunzip -c $fq | head -n 400 > fastq/$newname
done

# now we have dummy fastq files to work with 

