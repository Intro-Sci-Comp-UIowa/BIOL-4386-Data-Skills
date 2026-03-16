#!/bin/bash
########################
# author: Bin He
# date: 2020-03-26
# title: FastQC
# use: qsub fastqc.sh
#----------------------
# Scheduler parameters
#  Specify the queue to use
#$ -q BIO-INSTR
#  give a name to the job, default to script name
#$ -N fastqc
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

mkdir -p ../output/fastqc1 # create directory to hold the results
~/sw/FastQC/fastqc -t 6 -o ../output/fastqc1/ ../data/untrimmed_fastq/*.fastq* 
# -t 6 specifies the number of threads fastqc can use, taking advantage of the multi-thread core
# -o <DIR> specifies the output directory, where results will be saved
