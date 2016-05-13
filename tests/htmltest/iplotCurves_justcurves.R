theplot <- iplotCurves(grav$pheno, times,
                       chartOpts=list(curves_xlab="Time", curves_ylab="Root tip angle"))

htmlwidgets::saveWidget(theplot, file="iplotCurves_justcurves.html", selfcontained=FALSE)
