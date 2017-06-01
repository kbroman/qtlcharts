# nice example of iboxplot

library(qtlcharts)

# data from Alan Attie and colleagues, Biochemistry, University of Wisconsin-Madison
load("iboxplot_data.RData")
exdat <- exdat/1000
med <- apply(exdat, 1, median, na.rm=TRUE)
exdat <- exdat[order(med, decreasing=TRUE),]

# remove the target file, if it exists
file <- "iboxplot.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iboxplot(exdat, chartOpts=list(xlab="Mice", ylab="Gene expression",
                                          heading="<code>iboxplot</code>",
                                          caption=paste("<b><code>iboxplot</code> example:</b>",
                                                        "The top panel is like a set of 494 box plots: lines are drawn at a series",
                                                        "of percentiles for each of the distributions. Hover over a column in the top panel",
                                                        "and the corresponding distribution is show below; click for it to persist; click",
                                                        "again to make it go away."),
                                          footer=footer),
                    orderByMedian=FALSE, qu=c(0.01, 0.1, 0.25))
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
