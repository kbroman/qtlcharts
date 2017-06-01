# example of iplotCurves

library(qtlcharts)

data(grav)
times <- attr(grav, "time")
phe <- grav$pheno
wh <- seq(1, length(times), by=2)
times <- times[wh]
phe <- phe[,wh]

file <- "iplotCurves.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
                       chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Root tip angle (degrees)",
                                      scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
                                      scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs",
                                      heading="<code>iplotCurves</code>",
                                      caption=paste("<b><code>iplotCurves</code> example:</b>",
                                                    "The curves are linked to the two scatterplots below: hover over an",
                                                    "element in one panel, and the corresponding elements in the other panels will",
                                                    "be highlighted."),
                                      footer=footer,
                                      axispos=list(xtitle=25, ytitle=45, xlabel=5, ylabel=5)))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
