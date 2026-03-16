---
title: Workshop in markdown
author: Bin He, Leslie Speight
date: 2021-04-03
---

# Working with Sequence Data Tuesday Workshop 
Leslie Speight and Anna Ward, modified by Bin He on 2021-04-03

## Get data
You can complete this workshop on any of the following environments: your own computer (has to be Unix-like), fastx.divms.uiowa.edu, ARGON cluster. It is recommended that you use the fastx environment for this workshop because all steps have been tested there and that you have the convenience of having the GUI to view the R script output. If you choose to use ARGON, please use the following `ssh` command:

`ssh -p 40 -Y [HawkID]@argon.hpc.uiowa.edu` (remember to replace [HawkID] with your actual ID, and don't include the square brackets). The additional `-Y` flag will allow you to see R output via "X11 forwarding". If that fails for some reason, you will have to download the figure files to your local computer using `scp`, `rsync` or by [mounting](https://wiki.uiowa.edu/display/hpcdocs/Home+Accounts) your ARGON home to your local computer.

If you use your own computer's environment, some of the software installation described below may show errors, which you will need to troubleshoot yourself.

First, let's obtain the workshop data by cloning the following repository:

```bash
$ cd <path/to/workshop> # replace the second part with your directory name, don't include the ">" or "<"
$ git clone https://github.com/hezhaobin/2021-Data-Skills.git
$ cd 2021-Data-Skills/workshop/W12-seqeunce-data/ # hint: Tab don’t type!
$ ls
```
## Install software
### samtools
If you are on ARGON, `samtools` is already installed. All you need to do is to load it into your environment like this:
```bash
module load stack/2020.1 # required for loading samtools/1.10
module load samtools/1.10_intel-19.0.5.281
samtools --version # testing to make sure that it works
```
If you are on your own computer or on fastx environment (note that if you are on fastx, you can easily log on to ARGON and skip this step), then you will need to download the source code and compile the program yourself.

1. Go to your terminal, create a directory to hold the source code, e.g. `~/sw`, and `cd` into that folder.
1. Go to <http://www.htslib.org/download/>, right click on the green button that says "samtools-1.12" (version may be different) and "Copy Link Address".
1. Use `wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2` to download the file (the link may change depending on the version)
1. If download is successful (check by `ls -l` and look for the downloaded file), we can now extract the files using `tar xjvf samtools-1.12.tar.bz2` (tab don't type. If your file name is different from what is written, use yours.)
1. Follow the "Building and installing" instructions on the website above to build the program
    ```bash
    cd samtools-1.12
    mkdir ~/bin # create a directory to store compiled executables
    ./configure --prefix=~/bin # tell the installer to install the executable to the
                               # folder we just created
    make # compile
    make install # move the compiled executable to the folder above
    ```
1. While you have compiled and installed `samtools`, you still won't be able to invoke it (try `samtools --version`). This is because when you tell the shell to run `samtools`, it is looking for the executable file in its "run path", which you can see by `echo $PATH`. Thus our solution is to add `~/bin` to that `$PATH` variable:
    ```bash
    export PATH=~/bin:$PATH
    echo $PATH # do you see '~/bin' at the beginning of the output?
    ```
    This, however, would only work for the current login. Next time you log in, you would have to do this again. If you want to have this path added to your `$PATH` in every login, you can add the `export` command to your `~/.bashrc`.
    ```bash
    echo 'export PATH=~/bin:$PATH' >> ~/.bashrc # note there must be a single quote surrounding the export argument
    tail ~/.bashrc # do you see the line you just added? if so, next time you log in again the PATH variable will include ~/bin
    ```
    Now you should be able to execute `samtools --version`. Do you see output?

### sickle
Note that ARGON doesn't have either sickle or seqtk installed. So even if you use ARGON, you will need to install these two manually.

1. Clone the author's repository into your `~/src` folder or whatever you have called it: <https://github.com/najoshi/sickle>
1. `cd` into the folder and `make`
1. if no error is shown, you should now see an executable file called `sickle`. You can actually invoke it by `./sickle`. The `./` part tells the shell that you are invoking a program from the current directory. So this is another way you can invoke a self-installed program, by giving the full or relative path to the executable, e.g. `~/src/sickle/sickle`
1. If you want to use the same `~/bin` folder we created above, simply copy the executable to that folder. You should know how to do this part now. Once you do that, you should be able to invoke `sickle` without the path.

### seqtk
The same procedure as above. The github repository is here: <https://github.com/lh3/seqtk>

### qrqc
To install an R package, you need to have R installed in the environment. fastx and ARGON already have R installed, although for ARGON, you need to first "load" it using the instructions below. If you are on your own computer, you are responsible for installing R and optionally RStudio.

To load R in ARGON:
```bash
module load stack/2020.2
module load r/4.0.2_gcc-8.4.0
R # you should see the console if R is successfully loaded
```

The following commands can be executed either in the R console invoked from the command line environment, or in the graphic user interface, e.g. RStudio. If you want to use the command line, simply type `R` at the terminal and enter.

```r
> if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
> BiocManager::install('qrqc') # This is a Bioconductor package and helps us to visualize quality distribution across bases in reads
> library(qrqc) # if the installation was successful, you should see a long output here which means
                # the library is now loaded
> q("no")       # this will quit R so you can work on the other things
```

## Trimming low-quality bases with sickle and seqtk

Now, go back to your terminal and check to make sure that you are in the 'sequence-data'folder. Use 'ls' to see if the untreated1_chr4.fq is in the folder **TAB, DON'T TYPE**

### sickle

```bash
# sickle takes an input file through -f, a quality type through -t, and trimmed output with -o
sickle se -f untreated1_chr4.fq -t sanger -o untreated1_chr4_sickle.fq
```

If the terminal complains "bash: sickle: command not found..., it means the executable is not in one of the locations encoded in the $PATH variable or that it doesn't exist at all. Go back to the installation instructions above and make sure that you can call `sickle` at the terminal.

If you continue to have trouble editing the $PATH variable, you can also copy the `sickle` executable from the `~/src/sickle` folder (after it is compiled) to the current location, and append "./" to the command above so it looks like `./sickle se ...`

If the command ran successfully, you should see the following output
>   Total FastQ records: 204355
>   FastQ records kept: 203121
>   FastQ records discarded: 1234


### seqtk

See notes above for how to make sure that the executable is in the path, then type

```bash
# seqtk takes a single argument and outputs trimmed sequence through standard out
$ ./seqtk trimfq untreated1_chr4.fq > untreated1_chr4_trimfq.fq
```

## Comparing these results in R

Now, let's launch R either from the terminal if you are on ARGON, or you can choose to launch RStudio if you are in the fastx environment or your own computer. Be sure to check that your working directory is pointed to `sequence-data`. You can check the current working directory by `getwd()` and set the working directory by either `setwd(path/to/working/directory)` or use the file pane to navigate to the folder and use the "more" icon -> set as working directory

```r
> library(qrqc) # if you get an error, most likely you didn’t install the package successfully
                # go back to the beginning of the workshop and install `qrqc`
                
# Specify the file names using a character vector “c()”

> fqfiles <- c(none= "untreated1_chr4.fq", sickle= "untreated1_chr4_sickle.fq", trimfq= "untreated1_chr4_trimfq.fq")

# Below we use the `lapply()` function to apply a custom function, `readSeqFile()` to read the content of each of the three files
# We are loading each file in, and using qrqc’s readSeqFile

> seq_info <- lapply( fqfiles, function(file) { readSeqFile(file, hash=FALSE, kmer=FALSE) } )

# We only need qualities, se we turn off some of readSeqFiles’s other features
# note, if you type all 5 lines of code on the same line, you need a semi-colon “;” after each of line 2 and 3.

> quals <- mapply(function(sfq, name){
                    qs <- getQual(sfq)
                    qs$trimmer <- name
                    qs
        }, seq_info, names(fqfiles), SIMPLIFY=FALSE)   
#here we are extracting qualities as dataframe, and appending a column of which trimmer is used
# this is used in later plots 

> d <- do.call(rbind,quals)
# this combines separate dataframes in a list into single dataframes

> p1 <- ggplot(d)+geom_line(aes(x=position,y=mean,linetype=trimmer))
> p1 <- p1 + ylab("mean quality (sanger)")+ theme_bw()
> print(p1)
> ggsave("ggplot_mean_quality.png")
# visualize qualities 

# what do you see? 

> p2 <- qualPlot(seq_info, quartile.color=NULL, mean.color=NULL) + theme_bw()
> p2 <- p2 + ylab("quality (sanger)")
> print(p2)
> ggsave("qualPlot_mean_quality.png")
# uses qrqc’s qualPlot with list produces panel plots
# only shows 10% to 90% quantiles and lowes curve
```

If you are working on ARGON at the terminal through SSH and you don't see a new window popping up that displays the plots (it will take about 30-60 sec depending on the speed of your connection, then you may have forgotten to add the `-Y` flag when you issue the `ssh` command. If you still couldn't see the results, go back to the beginning of this workshop and see options for downloading the output files to your local computer.

## Counting Nucleotides
- We will be working in the terminal for this section
- We will use the Python implementation of `readfq`, `readfq.py`
    - `readfq()` takes a file object (a filename that has been opened) and will generate FASTA/FASTQ entried until it reaches the enc of the file or stream.
    - Each FASTA/FASTQ entry is returned by `readfq()` containing the entry's description, sequence, and quality.

```bash
$ cd Desktop/Seq_data/2020-Data-Skills/workshop/seqeunce-data/
$ ls  
# we are now gonna look at and use a simple program that counts the number of each IUPAC nucleotide in a file
$ vim nuccount.py
```

```python
#!/usr/bin/env python
# nuccount.py -- tally nucleotides in a file
import sys
from collections import Counter
from readfq import readfq
# Use Counter in the collections module to count nucleotides. Works much like Python dict

IUPAC_BASES = "ACGTRYSWKMBDHVN-."
# Defines all IUPAC nucleotides (standardized and unstandardized) , which we will use later to print bases in a consistent order. 

# initialize counter
counts = Counter()
# create a new Counter object

for name, seq, qual in readfq(sys.stdin):
    # uses the readfq function in the readfq module to read FASTQ/FASTA entries from the file handle argument into the name, seq, qual variables
    # for each sequence entry, add all its bases to the counter
    counts.update(seq.upper())
    # takes any iterable object and adds them to the counter. We convert all characters to uppercase with the upper( ) method, so that       lowercase soft-masked bases are also counted. 

# print the results
for base in IUPAC_BASES:
    print (base + "\t" + str(counts[base]))
# we iterate over all IUPAC bases and print their counts
```

- Now run the script
    ```bash
    $ cat contam.fastq | ./nuccount.py
    ```

## Indexed FASTA Files
This example uses the mouse genome (Ensembl release 75) for an example. You can
get this with:
    ```bash
    $ wget https://github.com/vsbuffalo/bds-files/raw/master/chapter-10-sequence/Mus_musculus.GRCm38.75.dna.chromosome.8.fa.gz
    ```

- Make sure you are working within /sequence-data/
- Extracting numerous random subsequences from a FASTA file can be quite computationally costly.
- A common computational strategy that allows for easy and fast random access is indexing the file. It allows us to easily extract subsequences

```bash
$ gunzip Mus_musculus.GRCm38.75.dna.chromosome.8.fa.gz
$ samtools faidx Mus_musculus.GRCm38.75.dna.chromosome.8.fa 8:123407082-123410744
```

- What do you see?
- `samtools faidx` allows for multiple regions at once, so we could do:

    ```bash
    $ samtools faidx Mus_musculus.GRCm38.75.dna.chromosome.8.fa 8:123407082-123410744 8:123518835-123536649
    ```
