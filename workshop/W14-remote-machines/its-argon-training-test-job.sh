#!/bin/bash

# This script is kindly provided by the UIowa ITS as part of their ARGON cluster training
# and modified by Bin He, Assistant Professor in the Biology Department, Apr 7th, 2021

# Specify the queue to use
#! -q all.q

# give a name to the job, default to script name
#$ -N test

# execute the job from the current working directory
#$ -cwd

# specify the file names for redictring the output and error messages
#$ -o test.out
#$ -e test.err

# Send e-mail at beginning/end/suspension of job
#$ -m bes

# ---- Please edit the section below ----
# E-mail address to send to (replace <HawkID> with your actual HawkID)
#$ -M <HawkID>@uiowa.edu
# ---- End of the editing session ----

# good options to set for reproducibility
# from Vince Buffalo's Bioinformatic Data Skills, chapter on unix script
set -e
set -u
set -o pipefail

# Print information from the job into the output file
/bin/echo Running on compute node: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

# Sleep (wait and do nothing) for 30 seconds
sleep 30

# Print the end date of the job before exiting
echo Now it is: `date`

#Now try something that shouldn't work, so that an error will be written to the error file
echo A variable that is does not exist should give an error $NOTSET

exit
