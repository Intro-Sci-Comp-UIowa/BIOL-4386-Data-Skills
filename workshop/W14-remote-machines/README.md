---
title: Remote computing workshop
author: Bin He
date: 2021-04-07
---

# Couple of notes on common questions / misconceptions for remote computing
## Login vs compute nodes
This part may feel odd or counterintuitive -- if we already logged onto ARGON, are we not already utilizing the awesome computing powers? Well, actually no. The analogy I made in the class today actually go pretty far. Imagine that you are checking into a hotel. The login nodes (there are four, called login-1,2,3,4 at the time of writing this piece) are like the lobby of the hotel. You can do some casual stuff like checking out a map, sit on a sofa or refill your coffee -- all "light" tasks. Arguably the most important reason you check into a hotel is to sleep through the night, right? And you won't want to sleep in the lobby for sure, unless you are out of options. Imagine what would happen if all the guests choose to sleep in the lobby of a hotel! Unfortunately, the equivalent is happening pretty much every day on HPC systems, including ARGON. People didn't realize that they actually need to be assigned a computing node ("your room") and do the computation there ("enter and sleep").

## The SGE and `qsub / qstat / qdel` commands
On your own computer, you simply execute the commands at the terminal. So why do we have to go through the extra step of job submission, and what are all the gibberish `#$ -M` stuff about? If we go back to the hotel analogy, this is like you requesting a room from the hotel staff -- you need to tell the person what features you need in that room, e.g. how many beds, luxury or basic, with a living room or not, with air conditioning or not, facing the street or the yard......  Now, if you don't care about any of these, you can ignore all of that and just specify the "queue" with `#$ -q` flag (the hotel analogy doesn't work very well here, but imagine that you or your company own a suite of rooms for the duration of the conference and you get priority and discounted price if you check in to one of those rooms).

Briefly, the reason for all the qXX commands like the one mentioned in the section title is because we cannot directly interact with the computing nodes, and these commands act as a "conveyer" to transmit commands and data back and forth between the login node, which you are on, and the computing nodes, which you want to use for your job. Now that's not exactly true because you can actually "get on" to the computing node with `qlogin`. So which way should you use? For most of the jobs you should use the `qsub` approach. This forces you to write a script, which helps with reproducibility, and is also better for the cluster, because the `qlogin` method freezes more resources and make the cluster run less efficiently. For more discussion on this, see this [HPC wiki page](https://wiki.uiowa.edu/display/hpcdocs/Qlogin+for+Interactive+Sessions).

# Workshop
## Basic (required)
As you follow the [workshop](https://iowabiostat.github.io/hpc/1.html), you can either use the R code provided in the workshop, or you can use the python script JT has created (see below). I suggest you simply type in the commands and make sure that it works by executing it first on the computing node. Then, you should write a job script and use "qsub" to submit it to the cluster. You are responsible for writing that job script. In this week's feedback, you will be asked to provide the output of "qstat" to show that you have successfully submitted your job and the output file of the job.

```python
import time
for i in range(10):
    print(i)
    time.sleep(30)
```
## Intermediate (optional)
If you are comfortable with the basic workshop and would like to challenge yourself a little bit (this is by no means advanced), you can attempt at the activity below. The goal here is to perform a common task in next-generation sequencing analysis -- in fact often one of the first steps -- quality check. You will be using a sequencing file in the `fastq` format. The data file itself is obtained from the European Nucleotide Archive at this address: <ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR690/002/SRR6900282/SRR6900282.fastq.gz>. The dataset was part of larger collection originally published by Muñoz _et al._ 2018 (PMID: 30559369). The specific data file we will be using as an example was from an RNA-seq experiment profiling the transcriptome of a clinical strain of _Candida auris_ after 2 hours of antifungal treatment, to understand what genes have changed their expression in response to the drug. _C. auris_ is an emerging yeast pathogen that has been causing outbreaks in the US and throughout the world, and was on the top 5 watch list of CDC in 2019 ([link](https://www.cdc.gov/fungal/candida-auris/index.html)). You can also find more information specifically about this and other files at this [link](https://www.ebi.ac.uk/ena/browser/view/PRJNA445471).

```bash
# 1. Create a directory to hold the data, script and output of this analysis, e.g.
mkdir -p ~/Documents/remote-computing; cd ~/Documents/remote-computing
# 2. Get the data
#  - option 1: download from the source
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR690/002/SRR6900282/SRR6900282.fastq.gz
#  - option 2: copy from the downloaded file in the class folder
cp /Shared/class-BIOL_4386/W11-remote-computing/SRR6900282.fastq.gz ./
# 3. Load the fastqc module (read more about the tool by googling its name)
module load stack/2020.2
module load fastqc/0.11.9_gcc-8.4.0
fastqc --version
# 4. Run fastqc (don't actually run the following command at the login node)
#    or if you do try to run it at the login node just to test that it works
#    once you see some output, use Ctrl+c to kill it
# fastqc -t 6 -o ./ SRR6900282.fastq.gz
# 5. Write a script that does steps 3 and 4 and use qsub to submit it
#    there is a sample script to get you started in this folder
# 6. When you are done editing the script, try submitting it
qsub fastqc.sh # if you wrote your own script file with a different name, use that
# 7. Check the status of your job
qstat -u <HawkID> # replace <HawkID> with your hawkID, don't include "<>"
#    you may have to do the above multiple times until the job is done.
#    you should also receive an email when the job is done.
# 8. List the files in your current directory and examine their content with `less`
# 9. Download the output files with scp, rsync, or mount your ARGON home drive (google)
```
