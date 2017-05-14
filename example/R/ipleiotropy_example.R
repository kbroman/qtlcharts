# example of ipleiotropy

library(qtlcharts)
library(qtl)

data(grav)
grav <- calc.genoprob(grav[1,], step=1)
out <- scanone(grav, phe=c(156, 241), method="hk")

file <- "ipleiotropy.html"
if(file.exists(file)) unlink(file)

theplot <- ipleiotropy(grav, out, chr=1, phe=c(156, 241), lod=1:2,
                       chartOpts=list(title="ipleiotropy example"), digits=3)
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)

file.rename(file, file.path("..", file))
