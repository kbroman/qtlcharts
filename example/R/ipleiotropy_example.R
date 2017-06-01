# example of ipleiotropy

library(qtlcharts)
library(qtl)

data(grav)
grav <- calc.genoprob(grav[1,], step=1)
out <- scanone(grav, phe=c(156, 241), method="hk")

file <- "ipleiotropy.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- ipleiotropy(grav, out, chr=1, phe=c(156, 241), lod=1:2,
                       chartOpts=list(heading="<code>ipleiotropy</code>",
                                      footer=footer,
                                      caption=paste("<b><code>ipleiotropy</code> example:</b>",
                                                    "Use the double-slider below the LOD curve plot to select two QTL positions,",
                                                    "whose genotypes will then be used to color the points in the right panel.")),
                       digits=3)
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)

file.rename(file, file.path("..", file))
