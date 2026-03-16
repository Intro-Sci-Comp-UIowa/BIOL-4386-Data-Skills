#!/bin/bash
########################
# author: Bin He
# date: 2020-04-07
# title: Variant Calling
# use: qsub -t 1-3 run_variant_calling.sh
#----------------------
# Scheduler parameters
#  Specify the queue to use
#$ -q BIO-INSTR
#  give a name to the job, default to script name
#$ -N variant
#  execute the job from the current working directory
#$ -cwd
#  Request 10 slots in a shared memory environment
#$ -pe smp 10 
#  Specify the directory to save the job logs
#$ -o ./job-log/
#$ -e ./job-log/
#  Send e-mail at end/abort of job
#$ -m ea
#  E-mail address to send to
#$ -M <HawkID>@uiowa.edu
#----------------------
########################

# these are useful flags to set to make the code more robust to failure
# copied from Vince Buffalo's Bioinformatic Data Analysis book
set -eo pipefail

genome=../data/ref_genome/ecoli_rel606.fasta

bwa index $genome

mkdir -p ../output/{sam,bam,bcf,vcf}

fq=$(awk NR==$SGE_TASK_ID ../output/trimmed/SRR_ID.txt) # this will assign the $SGE_TASK_ID'th line in the SRR_ID.txt to $fq

echo "working with file $fq1"

base=$(basename $fq _1.trim.fastq.gz)
echo "base name is $base"

fq1=../output/trimmed/${base}_1.trim.fastq.gz
fq2=../output/trimmed/${base}_2.trim.fastq.gz
sam=../output/sam/${base}.aligned.sam
bam=../output/bam/${base}.aligned.bam
sorted_bam=../output/bam/${base}.aligned.sorted.bam
raw_bcf=../output/bcf/${base}_raw.bcf
variants=../output/bcf/${base}_variants.vcf
final_variants=../output/vcf/${base}_final_variants.vcf 

bwa mem -t 10 $genome $fq1 $fq2 > $sam  # use 10 threads
samtools view -S -b $sam > $bam        
samtools sort -@ 10 -o $sorted_bam $bam # use 1+9 threads 
samtools index $sorted_bam
bcftools mpileup -O b -o $raw_bcf -f $genome $sorted_bam
bcftools call --ploidy 1 -m -v -o $variants $raw_bcf 
vcfutils.pl varFilter $variants > $final_variants

echo "done"
