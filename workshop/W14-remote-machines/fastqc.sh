#!/bin/bash
########################
# author: Bin He
# date: 2020-03-26
# title: FastQC
# use: qsub fastqc.sh
########################
# ----------------------
#  Scheduler parameters
# ----------------------
#  Specify the queue to use
#$ -q BIO-INSTR
#  give a name to the job, default to script name
#$ -N fastqc
#  execute the job from the current working directory
#$ -cwd
#  Request 10 slots in a shared memory environment
#$ -pe smp 10 
#  Specify the directory to save the job logs
#$ -j y
#  Send e-mail at end/abort of job
#$ -m ea
# ---------------- edit the following part ---------------
#  E-mail address to send to (change <HawkID> to yours)
#$ -M <HawkID>@uiowa.edu
#---------------------------------------------------------

# these are useful flags to set to make the code more robust to failure
# copied from Vince Buffalo's Bioinformatic Data Analysis book
set -eo pipefail

# load fastqc
module load stack/2020.2
module load fastqc

# the actual command to run
fastqc -t 10 -o ./ SRR6900282.fastq.gz
# -t N     specifies the number of threads fastqc can use
#          note, N must be equal to or less than the number of slots (cores)
#          requested, which is specified by the #$ -pe smp N at the top
# -o ./    specifies the output directory, where results will be saved
