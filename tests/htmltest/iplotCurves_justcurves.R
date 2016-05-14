# plug in some missing values
phe <- as.matrix(grav$pheno)
phe[14,ncol(grav$pheno)] <- NA
phe[sample(prod(dim(phe)), 200)] <- NA

theplot <- iplotCurves(phe, times,
                       chartOpts=list(curves_xlab="Time", curves_ylab="Root tip angle"))

htmlwidgets::saveWidget(theplot, file="iplotCurves_justcurves.html", selfcontained=FALSE)
