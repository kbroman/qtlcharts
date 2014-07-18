# example of iplotScanone

library(qtlcharts)

data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)

file <- "../iplotScanone.html"
if(file.exists(file)) unlink(file)

iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
             title="iplotScanone example",
             onefile=TRUE, openfile=FALSE, file=file,
             caption=c("Hover over marker positions on the LOD curve to see the marker names. ",
               "Click on a marker to view the phenotype &times; genotype plot on the right. ",
               "In the phenotype &times; genotype plot, the intervals indicate the mean ",
               "&plusmn; 2 SE.<br><br>\n",
               "<a style=\"text-decoration:none;\" href=\"http://kbroman.org/qtlcharts\">R/qtlcharts</a>"))
