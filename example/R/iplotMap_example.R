# example of iplotMap

library(qtlcharts)
library(qtl)
data(hyper)
map <- pull.map(hyper)

file <- "iplotMap.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplotMap(map, shift=TRUE,
                    chartOpts=list(heading="<code>iplotMap</code>",
                                   caption=paste("<b><code>iplotMap</code> example:</b>",
                                                 "Hover over marker positions to view the marker names and positions.",
                                                 "Enter a marker name in the search box, to have it highlighted."),
                                   footer=footer,
                                   axispos=list(xtitle=25, ytitle=35, xlabel=5, ylabel=5)))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
