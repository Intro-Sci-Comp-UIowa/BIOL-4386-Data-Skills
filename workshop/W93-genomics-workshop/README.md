---
title:
author:
date:
---

Genomics Workshop
=================

## Before we start

- This workshop is entirely based on <https://datacarpentry.org/wrangling-genomics/>
- This workshop is intended to be completed on the ARGON computing cluster at the University of Iowa.
    a. if you are working off campus, first download and connect to VPN, following the instructions [here](https://its.uiowa.edu/vpn)
    b. if your personal computer is Windows-based and not set up for terminal access, log on to the fastx environment in your browser window.
    c. to connect to ARGON, use `$ ssh -Y <HawkID>@argon.hpc.uiowa.edu`. You will need to have 2-step verification set up.
- Clone this repository
    ```bash
    $ cd
    $ git clone https://github.com/hezhaobin/2021-Data-Skills.git
    ```

## Setup

Instructions based on <https://datacarpentry.org/genomics-workshop/setup.html>

### Install software

1. Preparation

    I suggest you create a folder named "sw" to contain all of your custom-installed software on ARGON
    ```sh
    $ cd # go to your home directory
    $ mkdir sw; cd sw # create and enter the sw folder
    ```

1. FastQC

    This is a commonly used quality checking program for FASTQ files
    ```sh
    $ wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
    $ unzip fastqc_v0.11.9.zip
    $ cd FastQC # tab don't type. your folder may have a different name
    $ chmod 755 fastqc # this makes the wrapper code executable
    ```

1. MultiQC

    This is a tool that can aggregate FastQC results for individual fastq files
    ```bash
    $ module load python/3.7.0 # this loads the Python version 3.7.0
    $ pip install --user multiqc # --user tells pip to install the software into the user's directory, instead of the system directory
    $ multiqc -h # if you see the help menu, it tells you that your installation is successful
    ```

1. Trimmomatic

    [A good introduction](https://wikis.utexas.edu/display/CoreNGSTools/Pre-processing+raw+sequences#Pre-processingrawsequences-TrimmingsequencesTrimming) to why you would want to trim your reads before downstream analysis.
    ```sh
    $ cd ~/sw
    $ wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
    $ unzip Trimmomatic-0.39.zip
    $ cd Trimmomatic-0.39
    $ java -jar trimmomatic-0.39.jar # if you see the options for the program, that means installation is successful
    ```

### Download data

```bash
# first, cd into the data folder
# $ wget -O 7726454.zip https://ndownloader.figshare.com/articles/7726454/versions/2
$ cd ~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/script
$ sh download_fastq.sh
$ ls ../data/untrimmed_fastq # check to make sure that there are 6 .fastq.gz files in the folder
```

## Analysis
### Understand the data structure and format

It is important to understand the setup of the experiment and how the data is organized before you analyze it. This applies to both your own data and other people's data.

1. Download and view the metadata
   ```sh
   # change to the workshop's directory
   $ cd data
   $ wget https://raw.githubusercontent.com/datacarpentry/wrangling-genomics/gh-pages/files/Ecoli_metadata_composite.csv
   $ head Ecoli_metadata_composite.csv | column -t -s "," # this is an easy (imperfect) way to format a csv file for viewing
   $ module load R # let's examine it using R
   $ R
   ```
   ```r
   # These are R codes that you should type inside the R console (without the other panels in RStudio
   > meta <- read.csv("Ecoli_metadata_composite.csv", header=TRUE)

   # now you can use various tools you learned in the R class to inspect the data
   # if you want to use the great tidyverse package, you will need to install it first
   # > install.packages("tidyverse")
   # > library(tidyverse)
   # > meta <- read_csv("Ecoli_metadata_composite.csv")
   # > meta %>% count(generation)
   ```

   Based on the metadata, can you answer the following questions?

   - How many different generations exist in the data?
       `> table(meta$generation)`
   - How many rows and how many columns are in this data?
       `> dim(meta)`
   - How many citrate+ mutants have been recorded in Ara-3?
       `> table(meta$cit)`
   - How many hypermutable mutants have been recorded in Ara-3?
       `> table(meta$mutator)`


1. Examine the FASTQ format
    - if you are still in R, use `q('no')` to quit
    ```bash
    $ cd untrimmed_fastq # tab, don't type. if double tab still doesn't show the untrimmed_fastq folder, check where you are by typing `pwd`
    $ zcat SRR2584866_1.fastq.gz | head # this shows you the first 10 lines of the fastq file. it should look familiar to you now, right?
    ```

### Quality control
**It is always important to know the quality of your data, not just nextgen sequencing, but ANY data**

We will use FastQC, a java program that is very popular in the nextgen sequencing analysis community. You should have downloaded and unpacked the program in the set up part. Now let's test it

#### Learn about FastQC
```bash
$ ~/sw/FastQC/fastqc -h # tab, don't type. if you get an error, make sure that you have installed the program correctly, and have made the script executable
```

What did you learn from the help menu?

#### Assessing quality using FastQC
1. Make sure that you are in the `untrimmed_fastq` directory. Check by `pwd` and `ls`. Make sure that you can see the `<name>.fastq.gz` files
1. Run FastQC on all fastq files
    ```bash
    $ ~/sw/FastQC/fastqc *.fastq* # tab don't type, except for the last part. wild cards disables tab complete
    $ mkdir ../../output/fastqc   # create a folder in the output directory to store all fastqc results
    $ mv *fastqc* ../../output/fastqc # tab don't type! move the results to the newly created folder
    $ cd ../../output/fastqc      # change directory to the output results
    $ multiqc .                   # this runs multiqc
    ```
1. Now, to view the results, we need a graphic user interface. You have two options here (it's ok if you didn't get this part to work, but give it a try):

    - Map your Argon home account directory locally, follow this [instruction](https://wiki.uiowa.edu/display/hpcdocs/Home+Accounts), which you have learned before. Then navigate to the folder that contains the `output/fastqc` and copy the results to your local directory, and view the `multiqc_report.html`
    - Secure copy the results to your local computer
        ```bash
        # first open a new terminal window, not the one that you used to connect to ARGON
        $ mkdir -p ~/tmp/fastqc; cd ~/tmp/fastqc   # create a temporary folder to hold the results
        $ rsync -avz -e ssh <HawkID>@argon.hpc.uiowa.edu:~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/output/fastqc/ ./
        # if the rsync command fails, one possibility is that your directory is different from ~/2021-Data-Skills/... 
        ```

1. View the text output
    If you had trouble downloading the files either using mapped drive or with `rsync`, know that you can also rely on the plain text output
    Now go back to your terminal with the ARGON session
    ```bash
    $ pwd # check where you are. if necessary, cd into the `genomics-workshop` folder
    $ mkdir docs # create a new level 1 folder to contain important documentation
    $ cd docs
    $ ln -s ../output/fastqc/multiqc_data/multiqc_fastqc.txt ./ # this creates a "shortcut" to a summary file produced by multiqc
    $ column -ts $'\t' multiqc_fastqc.txt | less -S # this prints the content of the file in a pretty format
    ```

### Trimming and Filtering
_Why do we need to trim the reads?_

The answer below is from [this website](https://wikis.utexas.edu/display/CoreNGSTools/Pre-processing+raw+sequences#Pre-processingrawsequences-TrimmingsequencesTrimming)

> There are two main reasons you may want to trim your sequences:
> 
> - As a quick way to remove 3' adapter contamination, when extra bases provide little additional information
>     - For example, 75+ bp ChIP-seq reads – 50 bases are more than enough for a good mapping, and trimming to 50 is easier than adapter removal, especially for paired end data.
>     - You would not choose this approach for RNA-seq data, where 3' bases may map to a different exon, and that is valuable information.
>         - Instead you would specifically remove adapter sequences.
> - Low quality base reads from the sequencer can cause an otherwise mappable sequence not to align
>     - This is more of an issue with sequencing for genome assembly – both bwa and bowtie2 seem to do fine with a few low quality bases, soft clipping them if necessary.

_Running Trimmomatic_

1. Copy the program and adapter sequence to the data folder
    ```bash
    $ pwd # notice where you are. if necessary, change directory to `untrimmed_fastq`
    $ cp ~/sw/Trimmomatic-0.39/trimmomatic-0.39.jar ./ # Tab don't type! Your folder name may be different from mine
    $ cp ~/sw/Trimmomatic-0.39/adapters/NexteraPE-PE.fa ./
    $ java -jar ./trimmomatic-0.39.jar PE SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
                                          SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz \
                                          SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz \
				          SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
    ```

    - For detailed explanation of the `trimmomatic` command above, see the author's [website](http://www.usadellab.org/cms/?page=trimmomatic)
    - Follow the [workshop website](https://datacarpentry.org/wrangling-genomics/03-trimming/index.html) to examine the output and answer the questions
        - What percent of reads did we discard from our sample? 2) What percent of reads did we keep both pairs?
        - What are the output files? How large are they compared to the input files, why?

1. Now let's try to automate the trimming by writing a script and submitting it to the ARGON scheduler
    First, let's create a file that records all the sample IDs so we can loop through them in a script

    ```bash
    # you should still be in the `untrimmed_fastq` folder. If not, cd into it
    $ for f in *_1.fastq.gz; do echo $(basename $f _1.fastq.gz); done > SRR_ID.txt
    $ cat SRR_ID.txt # you should see three lines, each containing the "base name" of the sample starting with SRR
    # now you can go to the `../../script` folder, edit and run the `trimmomatic.sh`
    $ cd ../../script
    $ vim trimmomatic.sh # tab don't type!
    ```
    Now try to understand what the script does. To submit the job, enter `$ qsub -t 1-3 trimmomatic.sh`, where 1-3 means there are 3 files to submit.

    Use `qstat -u <HawkID>` to check the status of your job. If the job finishes, you can use `qacct -j <JOB_ID>` to view the resource usage of your job. Also check the job output and standard error in the `job-log` folder.

## Variant calling (demonstration)
_Questions_

- How do I find sequence variants between my sample and a reference genome?

_Objectives_

- Understand the steps involved in variant calling.
- Describe the types of data formats encountered during variant calling.
- Use command line tools to perform variant calling.

_Procedures_

1. Download the reference genome for _E. coli_ REL606
    ```bash
    $ cd ~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/data # modify the path if yours is different
    $ mkdir ref_genome
    $ curl -L -o ./ref_genome/ecoli_rel606.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
    $ gunzip ./ref_genome/ecoli_rel606.fasta.gz
    ```

1. Index the reference genome
    > Indexing allows the aligner to quickly find potential alignment sites for query sequences in a genome, which saves time during alignment. Indexing the reference only has to be run once. The only reason you would want to create a new index is if you are working with a different reference genome or you are using a different tool for alignment.
    ```bash
    $ module load bwa # load the bwa aligner, which is also what we will use to index the genome
    $ bwa index ./ref_genome/ecoli_rel606.fasta
    ```

1. Align the reads to the reference genome
    1. We will first demonstrate alignment using a subset of the real data, which is smaller and takes less time to run
        ```bash
        $ curl -L -o sub.tar.gz https://ndownloader.figshare.com/files/14418248 # download the subset of data
        $ tar xzvf sub.tar.gz              # expand the compressed and archived file
        $ mv sub trimmed_fastq_small       # rename the folder to make it easier to understand/recall
        $ cd ..                            # return to the parent folder
        $ mkdir ./output/{sam,bam,bcf,vcf} # make a series of sub folders for the output
        $ ls ./output/                     # check to make sure that these folders are there
        ```
    2. A basic bwa alignment command looks like below
        `$ bwa mem ref_genome.fasta input_file_R1.fastq input_file_R2.fastq > output.sam`
	Check the [bwa options page](http://bio-bwa.sourceforge.net/bwa.shtml) to see all the options that are not used above.
    3. To actually perform the mapping, do the following
        ```bash
	$ bwa mem data/ref_genome/ecoli_rel606.fasta \
	          data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq \
		  data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq \
		  > output/sam/SRR2584866.aligned.sam
		  # the \ tells the shell that the command is not over yet
		  # this should take ~15s
		  # the original data will take a lot longer
	# now let's examine its output
	$ less -S ./output/sam/SRR2584866.aligned.sam 
	# can you understand the SAM format by now?
        ```
    4. Sort the BAM file by coordinates. This is needed for indexing and other downstream operations
        ```bash
	# load the necessary modules
	$ module load stack/2020.2 # this tells ARGON to use the most recent versions of the samtools and bcftools
	$ module load samtools; module load bcftools
	$ samtools --version; bcftools -v # check the versions of the software, and make a note so that you know how to reproduce the results
	# first we need to convert the SAM file to BAM, this will take ~10s
	$ samtools view -S -b output/sam/SRR2584866.aligned.sam > output/bam/SRR2584866.aligned.bam
	# next we will sort it, this will take a few seconds
	$ samtools sort -o output/bam/SRR2584866.aligned.sorted.bam output/bam/SRR2584866.aligned.bam
	# we can use another samtools command, flagstat, to learn more about this BAM file
	$ samtools flagstat output/bam/SRR2584866.aligned.sorted.bam
	```

1. Variant calling
    Variant call is a conclusion that there is a nucleotide difference vs. some reference at a given position in an individual genome or transcriptome, often referred to as a Single Nucleotide Polymorphism (SNP). The call is usually accompanied by an estimate of variant frequency and some measure of confidence.

    Instead of `samtools mpileup` we used in the book chapter, we will use `bcftools mpileup` here instead. This is because after version 1.9 of `samtools`, the `mpileup` function has been moved to `bcftools` -- before that users would use `samtools mpileup` to generate VCF/BCF files and pipe it to `bcftools call` for variant calling. But as both softwares are upgraded in their versions, there can be incompatibility between an earlier version of `samtools` with a later version of `bcftool`. To avoid such errors, the authors of the two packages decided to move the `mpileup` from `samtools` to `bcftools`. As a reminder, this illustrates the importance of documenting not only the script used to generate the output, but also the version numbers of the software packages, because results could change significantly between versions.
    In the command `vcftools mpileup`, the flag `-O b` tells `samtools` to generate a bcf format output file, `-o` specifies where to write the output file, and `-f` flags the path to the reference genome:
    1. Generate BCF files
        ```bash
	$ bcftools mpileup -O b -o output/bcf/SRR2584866_raw.bcf \
	-f data/ref_genome/ecoli_rel606.fasta output/bam/SRR2584866.aligned.sorted.bam  # this command will take ~1 min or longer depending on the load of the login node
	```
    1. Detect single nucleotide polymorphisms (SNPs)
        We need to specify the ploidy with `--ploidy`, which is one for the haploid _E. coli_. `-m` allows for multiallelic and rare variant-calling; `-v` tells the program to output variant sites only; `-o` specifies where to write the output files
	```bash
	$ bcftools call --ploidy 1 -m -v -o output/bcf/SRR2584866_variants.vcf output/bcf/SRR2584866_raw.bcf 
	$ grep -v "^##" output/bcf/SRR2584866_variants.vcf | column -t | less -S
	# can you figure out what information is being recorded?
	```
    1. Filter and report the SNP variants in VCF format
        This uses a custom PERL script as part of the `vcftools` suite
        ```bash
	$ vcfutils.pl varFilter output/bcf/SRR2584866_variants.vcf  > output/vcf/SRR2584866_final_variants.vcf
	$ vimdiff output/vcf/SRR2584866_final_variants.vcf output/bcf/SRR2584866_variants.vcf
	# can you tell what is the difference before and after the filtering? hint: vimdiff uses vim to display differences between two text files. use ":qa" to quit ("a" means all)
	```

    1. Challenge
        Use the `grep` and `wc` commands you learned before to find out how many variants were called
	```bash
	$                     # type your commands here
	# write your answers below
	# there are _____ variants in total
	```
1. Assess the alignment visually
    > It is often instructive to look at your data in a genome browser. Visualization will allow you to get a “feel” for the data, as well as detecting abnormalities and problems. Also, exploring the data in such a way may give you ideas for further analyses. As such, visualization tools are useful for exploratory analysis. In this lesson we will describe two different tools for visualization: a light-weight command-line based one and the Broad Institute’s Integrative Genomics Viewer (IGV) which requires software installation and transfer of files.

    1. First we need to index the BAM file before we could view it
        ```bash
	$ samtools index output/bam/SRR2584866.aligned.sorted.bam
	```
    1. Use `samtools tview`
        ```bash
	$ samtools tview output/bam/SRR2584866.aligned.sorted.bam data/ref_genome/ecoli_rel606.fasta
	# hint: record the position of the variants by viewing the VCF output above, and navigate to that line to see the reads supporting the variant call, e.g. CP000819.1:1521, where the first part is the sequence name and the second part the location (_E. coli_ has only one chromosome, so the sequence name is some arbitrary ID)
	```
	**Challenge**: What variant is present at position 4377265? What is the canonical nucleotide in that position?
    1. Use `IGV`
        This time we will use IGV on your local machine or on FastX, wherever you started the SSH
	1. Download the result files
	    ```bash
	    # note: you need to exit from ARGON (Ctrl+D) or start a new terminal window (just launch the terminal app again)
	    # now you are on your local machine or FastX
	    $ mkdir ~/Desktop/files_for_igv # a temporary folder that you can later delete
	    $ cd ~/Desktop/files_for_igv
	    $ scp -P 40 HawkID@argon.hpc.uiowa.edu:~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/output/bam/SRR2584866.aligned.sorted.bam ~/Desktop/files_for_igv
	    $ scp -P 40 HawkID@argon.hpc.uiowa.edu:~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/output/bam/SRR2584866.aligned.sorted.bam.bai ~/Desktop/files_for_igv
	    $ scp -P 40 HawkID@argon.hpc.uiowa.edu:~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/data/ref_genome/ecoli_rel606.fasta ~/Desktop/files_for_igv
	    $ scp -P 40 HawkID@argon.hpc.uiowa.edu:~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/output/vcf/SRR2584866_final_variants.vcf ~/Desktop/files_for_igv
	    ```
	1. Download Broad Institute Integrated Genome Viewer (IGV)
	    download the program from http://software.broadinstitute.org/software/igv/download
	1. Open IGV.
	1. Load our reference genome file (`ecoli_rel606.fasta`) into IGV using the “Load Genomes from File…“ option under the “Genomes” pull-down menu.
	1. Load our BAM file (`SRR2584866.aligned.sorted.bam`) using the “Load from File…“ option under the “File” pull-down menu.
	1. Do the same with our VCF file (`SRR2584866_final_variants.vcf`).

## Variant calling, automated script and job submission
```bash
# now you need to go back to the ARGON terminal
# cd into your ~/2021-Data-Skills/workshop/W13-extra-genomics-workshop/script folder
$ qsub -t 1-3 run_variant_calling.sh # this will submit the jobs to the scheduler
```
