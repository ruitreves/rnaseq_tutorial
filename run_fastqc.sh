#/bin/bash

mkdir -p quality_report/before_trim

fastqc fastq/* --outdir=quality_report/before_trim