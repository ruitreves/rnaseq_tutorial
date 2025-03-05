#!/bin/bash

# specify where fastq files are located. dont include any "/", only the folder name 

fastq_location="fastq"

# mkdir -p quality_report/before_trimming

# run fastqc

# fastqc ${fastq_location}/* --outdir quality_report/before_trimming

# then use a for loop to trim all fastq file with trimmomatic 

mkdir trimmed_fastq

for file in ${fastq_location}/*R1.fastq.gz; do
    filename=$(basename $file "_R1.fastq.gz")
    new_filename=${filename//_2024*}
    java -jar /Users/hardestylab4/Desktop/star/Trimmomatic-0.39/trimmomatic-0.39.jar \
	PE -threads 16 -phred33 \
	fastq/${filename}_R1.fastq.gz fastq/${filename}_R2.fastq.gz \
	trimmed_fastq/trimmed_paired${new_filename}_R1.fastq.gz trimmed_fastq/trimmed_unpaired${new_filename}_R1.fastq.gz \
	trimmed_fastq/trimmed_paired${new_filename}_R2.fastq.gz trimmed_fastq/trimmed_unpaired${new_filename}_R2.fastq.gz \
	ILLUMINACLIP:/Users/hardestylab4/Desktop/star/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10:2:TRUE LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 \
	MINLEN:36
done

# run fastqc again to see the effects of trimming

mkdir quality_report/after_trimming

fastqc trimmed_fastq/trimmed_paired* --outdir=quality_report/after_trimming

# now run star 

mkdir bams

for file in trimmed_fastq/trimmed_paired*R1.fastq.gz; do
    filename=$(basename $file "_R1.fastq.gz")
    sample=${filename//trimmed_paired}
    echo $sample
    STAR --runThreadN 16 \
        --readFilesIn trimmed_fastq/${filename}_R1.fastq.gz trimmed_fastq/${filename}_R2.fastq.gz \
        --readFilesCommand gunzip -c \
        --genomeDir /Users/hardestylab4/Desktop/star/data/index_39 \
        --outSAMtype BAM SortedByCoordinate \
        --outFileNamePrefix bams/$sample
done

# then run featureCounts

mkdir counts

for file in bams/*.bam; do 
    filename=$(basename $file)
    sample=${filename//Aligned*}
    featureCounts --largestOverlap -a /Users/hardestylab4/Desktop/star/data/ref/Mus_musculus.GRCm39.112.gtf \
    -t exon -g gene_id -s 0 -p --countReadPairs -T 8 \
    -o counts/${sample}_counts.txt $file
done

