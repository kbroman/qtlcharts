# example of iplotScanone

library(qtlcharts)
library(qtl)

data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)

file <- "iplotScanone.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
                        chartOpts=list(heading="<code>iplotScanone</code>",
                                       caption=paste("<b><code>iplotScanone</code> example:</b>",
                                                     "Hover over marker positions on the LOD curve to see the marker names.",
                                                     "Click on a marker to view the phenotype &times; genotype plot on the right.",
                                                     "In the phenotype &times; genotype plot, the intervals indicate the mean",
                                                     "&plusmn; 2 SE."),
                                       footer=footer,
                                       axispos=list(xtitle=25, ytitle=40, xlabel=5, ylabel=5)))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
