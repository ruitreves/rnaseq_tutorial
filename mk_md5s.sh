#!/bin/bash

mkdir rui_md5s

for file in fastq/*1.fq.gz; do
    R1=$(basename $file)
    R2=${R1/_1/_2}
    sample_name=${R1%%_*}
    echo $R1
    echo $R2
    echo $sample_name
    md5sum-lite "fastq/$R1" "fastq/$R2" > rui_md5s/rui_${sample_name}_MD5.txt
done
    