# nice example of iboxplot

library(qtlcharts)

# data from Alan Attie and colleagues, Biochemistry, University of Wisconsin-Madison
load("hypo.RData")
hypo <- t(hypo.mlratio)
med <- apply(hypo, 1, median, na.rm=TRUE)
hypo <- hypo[order(med, decreasing=TRUE),]

# remove the target file, if it exists
file <- "../iboxplot_example.html"
if(file.exists(file)) unlink(file)

# onefile=TRUE makes the resulting html file all-inclusive (javascript + css + data)
#     this is a bit wasteful of space, but it's easy
iboxplot(hypo, title="iboxplot example", chartOpts=list(xlab="Mice", ylab="Gene expression"),
         orderByMedian=FALSE, onefile=TRUE, openfile=FALSE, file=file,
         qu=c(0.01, 0.1, 0.25))
         
