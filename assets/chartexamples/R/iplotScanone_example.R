# example of iplotScanone

library(qtlcharts)

data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)

file <- "../iplotScanone_example.html"
if(file.exists(file)) unlink(file)

iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
             title="iplotScanone example",
             onefile=TRUE, openfile=FALSE, file=file)
