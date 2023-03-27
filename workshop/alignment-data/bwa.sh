#!/bin/bash
########################
# author: Bin He
# date: 2020-04-18
# title: bwa mem align
# use: qsub bwa.sh
########################
# ----------------------
#  Scheduler parameters
# ----------------------
#  Specify the queue to use
#$ -q BIO-INSTR
#  give a name to the job, default to script name
#$ -N bwa
#  execute the job from the current working directory
#$ -cwd
#  Request 10 slots in a shared memory environment
#$ -pe smp 10 
#  Send e-mail at end/abort of job
#$ -m ea
# ---------------- edit the following part ---------------
#  E-mail address to send to (change <HawkID> to yours)
#$ -M HawkID@uiowa.edu
#---------------------------------------------------------

# these are useful flags to set to make the code more robust to failure
# copied from Vince Buffalo's Bioinformatic Data Analysis book
set -eo pipefail

# load fastqc
module load stack/2020.2
module load bwa
module load samtools

# the actual command to run
echo "-------- bwa align -------"
bwa mem -t 10 ./genome/Cand_auris_B8441.fna.gz ./SRR6900282.fastq.gz > ./SRR6900282.aln.sam
# -t N     specifies the number of threads fastqc can use
#          note, N must be equal to or less than the number of slots (cores)
#          requested, which is specified by the #$ -pe smp N at the top
# others   the rest of the commands can be read on http://bio-bwa.sourceforge.net/bwa.shtml

# convert the SAM file to BAM
echo "-------- SAM -> BAM -------"
samtools view -b -@ 10 SRR6900282.aln.sam -o SRR6900282.bam
# -@ 10 tells samtools to use 10 threads

# sort the BAM file
echo "-------- Sorting BAM -------"
samtools sort -@ 10 -T /localscratch/aln.sorted -o SRR6900282.sorted.bam SRR6900282.bam

# index the sorted BAM file
echo "-------- Indexing BAM -------"
samtools index -@ 10 SRR6900282.sorted.bam
