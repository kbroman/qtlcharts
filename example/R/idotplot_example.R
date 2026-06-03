# example of idotplot

library(qtlcharts)
data(geneExpr)

file <- "idotplot.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- idotplot(geneExpr$genotype, geneExpr$expr[,1],
                    chartOpts=list(xlab="genotype", ylab="expression phenotype",
                                   xcatlabels=c("AA", "AB", "BB"),
                                   margin=list(top=10, bottom=50, left=60, right=10),
                                   axispos=list(xtitle=30, ytitle=40, xlabel=5, ylabel=5),
                                   heading="<code>idotplot</code>",
                                   footer=footer,
                                   caption=paste("<b><code>idotplot</code> example:</b>",
                                                 "A scatterplot but with one variable being",
                                                 "qualitative (genotype in this case).")))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
