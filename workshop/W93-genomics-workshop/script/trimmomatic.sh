#!/bin/bash
########################
# author: Bin He
# date: 2020-03-26
# title: Trimmomatic trimming
# use: qsub -t 1-n ./trimmomatic.sh
#----------------------
# Scheduler parameters
#  Specify the queue to use
#$ -q BIO-INSTR
#  give a name to the job, default to script name
#$ -N trimmomatic
#  execute the job from the current working directory
#$ -cwd
#  Request 6 slots in a shared memory environment
#$ -pe smp 6 
#  Specify the directory to save the job logs
#$ -o ./job-log/$JOB_NAME_$TASK_ID.out
#$ -e ./job-log/$JOB_NAME_$TASK_ID.err
#  Send e-mail at end/abort of job
#$ -m ea
#  E-mail address to send to
#$ -M <HawkID>@uiowa.edu
#----------------------
########################

# these are useful flags to set to make the code more robust to failure
# copied from Vince Buffalo's Bioinformatic Data Analysis book
set -eo pipefail

# create directory to hold the results
mkdir -p ../output/trimmed 

# we will use a trick called array jobs. think of it as a loop where each turn, the main job script will
# spawn an instance of itself and submit a sub-job with a different input file you specified. this is useful
# when you need to submit tens to thousands of small jobs, each doing the same thing but on different input
# files. see <https://wiki.uiowa.edu/display/hpcdocs/Basic+Job+Submission> (search for array) for details

# to do array jobs, we will use a special variable called $SGE_TASK_ID
# when we submit an array job, we use the `-t n:N:s` flag to specify the start, end and step size of the index
# which is passed on to the script. at run time, the variable $SGE_TASK_ID will be replaced by n-N, increasing 
# by s each time. you can cleverly use this to loop over your array of input files. below is one way to do it,
# using the command line program `awk` combined with a text file containing the "base name" of the input files

fq=$(awk NR==$SGE_TASK_ID ../data/untrimmed_fastq/SRR_ID.txt) # this will assign the $SGE_TASK_ID'th line in the SRR_ID.txt to $fq
in=../data/untrimmed_fastq   # specify the path to the input files
out=../output/trimmed        # specify the path for the results
sw=$HOME/sw/Trimmomatic-0.39 # specify the path to the trimmomatic program

# main program
java -jar ${sw}/trimmomatic-0.39.jar PE ${in}/${fq}_1.fastq.gz ${in}/${fq}_2.fastq.gz \
	                                                        ${out}/${fq}_1.trim.fastq.gz ${out}/${fq}_1un.trim.fastq.gz \
	                                                        ${out}/${fq}_2.trim.fastq.gz ${out}/${fq}_2un.trim.fastq.gz \
															SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:${sw}/adapters/NexteraPE-PE.fa:2:40:15
