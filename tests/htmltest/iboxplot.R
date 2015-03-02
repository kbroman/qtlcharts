theplot <- iboxplot(t(grav$pheno), breaks=51, orderByMedian=FALSE,
                    chartOpts=list(xlab="Time index", ylab="Root tip angle (degrees)"))

htmlwidgets::saveWidget(theplot, file="iboxplot.html", selfcontained=FALSE)
