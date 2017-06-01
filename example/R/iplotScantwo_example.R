# example of iplotScantwo

library(qtlcharts)
library(qtl)

data(hyper)
hyper <- hyper[c(1,4,6,15),]
hyper <- calc.genoprob(hyper, step=2)
out2 <- scantwo(hyper, method="em", verbose=FALSE)

file <- "iplotScantwo.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize(height=800, width=1200)
theplot <- iplotScantwo(out2, hyper, digits=3,
                        chartOpts=list(heading="<code>iplotScantwo</code>",
                                       caption=paste("<b><code>iplotScantwo</code> example:</b>",
                                                     'Use the drop-down menus to select the LOD scores to plot. ',
                                                     'Hover over the heatmap to view the LOD scores; click to view cross-sectional ',
                                                     'slices below and QTL effects plots to the right.'),
                                       footer=footer,
                                       axispos=c(xtitle=25,ytitle=40,xlabel=5,ylabel=5)))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
