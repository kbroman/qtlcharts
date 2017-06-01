# example of iplotCorr

library(qtlcharts)
data(geneExpr)

file <- "iplotCorr.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplotCorr(geneExpr$expr, geneExpr$genotype, reorder=TRUE,
                     chartOpts=list(cortitle="Correlation matrix",
                                    scattitle="Scatterplot",
                                    heading="<code>iplotCorr</code>",
                                    footer=footer,
                                    caption=paste("<b><code>iplotCorr</code> example:</b>",
                                                  "The left panel is an image of a correlation matrix, with",
                                                  "blue = -1 and red = +1. Hover over pixels in the correlation matrix",
                                                  "on the left to see the values; click to see the corresponding",
                                                  "scatterplot on the right.")))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
