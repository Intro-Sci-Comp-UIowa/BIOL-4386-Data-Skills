# install required library
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

    BiocManager::install("qrqc")

# load library
library(qrqc)

# make sure that you are in the right directory, where the fq file is
getwd()

# load files
fqfiles <- c(none="untreated1_chr4.fq", sickle = "untreated1_chr4_sickle.fq", trimfq = "untreated1_chr4_trimfq.fq")
seq_info <- lapply(fqfiles, function(file){
	readSeqFile(file, hash = FALSE, kmer = FALSE)
})

# extract quality information
quals <- mapply(function(sfq, name){
	qs <- getQual(sfq)
	qs$trimmer <- name
	qs
}, seq_info, names(fqfiles), SIMPLIFY=FALSE)

# combine the results
d <- do.call(rbind, quals)

# visualize qualities
p1 <- ggplot(d) + geom_line(aes(x=position, y = mean, linetype=trimmer))
p1 <- p1 + ylab("mean quality(sanger)") + theme_bw()
print(p1)

# Use qrqc's qualPlot, note that there will be a warning when you execute the command
#   probably due to the software version difference between what the author used and
#   what we have now.
p2 <- qualPlot(seq_info, quartile.color=NULL, mean.color=NULL) + theme_bw()
p2 <- p2 + scale_y_continuous("quality (sanger)")
print(p2)
