---
title: W6 challenge
author: Bin He
date: 2021-03-02
---

This is for those of you who are already familiar with the unix command line tools or those who feel like more practice after finishing our normal workshop. The task here isn’t super difficult, and could well be something that you may encounter in your own analysis. So give it a try, although don't be obssessed -- give yourself a time limit, say 30 min, and just stop after time is up.

Extract information from a genome annotation file (.gtf)
========================================================

Prepare Data
------------
- Go to `~/Documents` in your terminal and create a folder for this exercise, e.g. “W6-challenge”, and `cd` into it
- Obtain the gtf file by issuing the command
    ```bash
    $ wget ftp://ftp.ensembl.org/pub/release-93/gtf/homo_sapiens/Homo_sapiens.GRCh38.93.gtf.gz
    $ gunzip Homo_sapiens.GRCh38.93.gtf.gz # will take ~10 sec
    ```

Answer Questions
----------------
You may need to review the [GTF](https://useast.ensembl.org/info/website/upload/gff.html) (General Transfer Format) file format to know which column to use to answer the following questions.
- How many genes are there in this build of the human genome?
- Now let’s pick a gene and learn a bit more about it. If you don't have a favorite gene, try "FOXP2", a gene that encodes a transcription factor linked to human language development (see [here](https://www.sciencedirect.com/science/article/pii/S096098221831546X) but see disputes [here](https://doi.org/10.1016/j.cell.2018.06.048))
    - first, let's extract the information pertaining to the gene we chose:
        1. First select all lines that contain the gene name; 
        1. Then select those lines from the last step that contain the word “protein_coding”;
        1. Finally write the output to a file named “my_gene.txt”.
    - Now only look at those lines where the second column says “ensembl_havana” and answer the following questions
        1. Which chromosome is this gene on?
        1. How long is this gene?
        1. How many exons are there?
        1. How many coding exons there are?
        1. how many amino acids does this gene have?
