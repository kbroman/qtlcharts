# example of iplotScanone

library(qtlcharts)
library(qtl)

data(hyper)
hyper <- hyper[c(1,4,6,15),]
hyper <- calc.genoprob(hyper, step=2)
out2 <- scantwo(hyper, method="em", verbose=FALSE)

file <- "../iplotScantwo.html"
if(file.exists(file)) unlink(file)

iplotScantwo(out2, hyper,
             title="iplotScantwo example",
             onefile=TRUE, openfile=FALSE, file=file,
             caption=c('Use the drop-down menus to select the LOD scores to plot. ',
                       'Hover over the heatmap to view the LOD scores; click to view cross-sectional ',
                       'slices below and QTL effects plots to the right.<br><br>\n',
                       '</p><hr/><p class="caption"><a style="text-decoration:none;" ',
                       'href="http://kbroman.org/qtlcharts">R/qtlcharts</a>'),
             chartOpts=list(axispos=c(xtitle=25,ytitle=40,xlabel=5,ylabel=5)))
