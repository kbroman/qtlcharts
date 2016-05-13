# plug in a missing value
phe <- grav$pheno[14,ncol(grav$pheno)] <- NA

theplot <- iplotCurves(phe, times,
                       chartOpts=list(curves_xlab="Time", curves_ylab="Root tip angle"))

htmlwidgets::saveWidget(theplot, file="iplotCurves_justcurves.html", selfcontained=FALSE)
