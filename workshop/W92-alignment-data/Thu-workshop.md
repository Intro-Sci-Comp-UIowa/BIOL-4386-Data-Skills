---
title: Thursday workshop for Working with Alignment Data
author: Madeline Woolery, Bin he
date: 2020-04-05
---

## Variant calling
### The Pileup Format
This format is a plain-text format that stacks or "piles up" aligned reads at each chromosome position to summarize the reads' bases. This format is useful to identify variants. In this section of the workshop, you will be applying the samtools mpileup command to inspect the chromosome region you inspected in the previous section.

#### Using samtools mpileup

```bash
$ samtools mpileup --no-BAQ --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam
```

- As shown above, mpileup is another tool that requires the inputs to be in BAM format. However, the reference genome can be used in FASTA format using "--fasta-ref". "--region" limits the pileup to the region that was specified in the command. "--no-BAQ" disables the Base Alignment Quality which is an additional feature of mpileup.
- The outputs of this command are pileups and stacked mismatches. However, it is possible to output variant calls instead using mpileup.

#### Variant calling using `bcftools`
```bash
$ samtools mpileup -v --no-BAQ --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam \ 
> NA12891_CEU_sample.vcf.gz
```

- In this command, we have added the "-v" flag which indicates that VCF (or Variant Call Format) should be used. This command generates genotype likelihoods for every site in the specified region. This command then ends by telling mpileup to direct the output to a VCF file. There is a binary analog of VCF (called BCF) which could be specified in the command-line by replacing the "-v" flag with "--g". The resulting file is an intermediate file which can be used for further analysis steps.
- The "-u" flag can be used to force the output file to be uncompressed but this is not necessary to move on to the next step.
 
To view the intermediate file:
```bash
$ zgrep -v "^##" NA12891_CEU_sample.vcf.gz | \
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5$6,a[1],$9,$10}' 
```

bcftools call can then be used to process the information in the intermediate file to identify variant sites. You will need to check that it is downloaded.

```bash
$ module avail bcftools
$ module load bcftools
$ bcftools call -v -m NA12891_CEU_sample.vcf.gz > NA12891_CEU_sample_calls.vcf.gz
```

- "-m" stands for multiallelic caller
- "-v" means that only variant sites will be included in the output

```bash
$ zgrep -v "^##" NA12891_CEU_sample_calls.vcf.gz | \ 
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

- How many variant sites have been identified? 
- Was the site we studied earlier at 215,906,548 included? 
- Does this support our earlier conclusions regarding if this site is a true variant?
 
"QUAL" stands for quality scores which are PHRED-scaled values that estimate the probability the alternative allele is incorrect. The higher the QUAL score is, the more confidence there is in a base call. "ALT" stands for alternative allele. "." will be found in this column if there is no variant and in those cases "QUAL" represents the probability that the site does have a variant. By omitting "-v" from the command, we can view the call for our site of interest by including all nonvariant calls:

```bash
$ bcftools call -m NA12891_CEU_sample.vcf.gz | grep -v "^##" | \
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

- What does the QUAL score for site 215,906,548 tell you about this site?
- Calculate the probability that this site is variant:(HINT: Probability = 10^(-QUAL/10) * 100%))
 
VCF files have Format keys to sort the data which are described in the header. To view:

```bash
$ bcftools call -m NA12891_CEU_sample.vcf.gz > NA12891_CEU_sample_calls.vcf.gz
$ grep "FORMAT=<ID=GT" NA12891_CEU_sampple_calls.vcf.gz
```

- What does this format id correspond to?
- How about this format id?

```bash
$ grep "FORMAT=<ID=PL" NA12891_CEU_sample_calls.vcf.gz
```

### Base Alignment Quality
As we discussed before, one of the possible reasons for the misalignment in the region near position 215,906,547 is that it is a low complexity region consisting of G's and C's. Regions with issues like this can be studied by enabling the Base Alignment Quality (BAQ) tool that was disabled in earlier analyses. BAQ adjusts base qualities to reflect both the probability of an incorrect base call and the probability of a particular base being misaligned:

```bash
$ samtools mpileup -u -v --region 1:215906528-215906567 \ 
--fasta-ref human_g1k_v37.fasta NA12891_CEU_sample.bam > \ 
NA12891_CEU_sample_baq.vcf.gz
$ grep -v "^##" NA12891_CEU_sample_baq.vcf.gz | \ 
awk 'BEGIN{OFS="\t"} {split($8, a, ";"); print $1,$2,$4,$5,$6,a[1],$9,$10}'
```

As you may have noticed, site 215,906,547 which was previously called as a variant site using the bcftools call command is no longer considered to be a variant site. BAQ downweighted thee bases around the low complexity region due to the higher probability that the bases were misaligned.
