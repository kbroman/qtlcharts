theplot <- iplotCurves(grav$pheno, times,
                       grav$pheno[,c("T30", "T240")],
                       grav$pheno[,c("T240", "T480")],
                       chartOpts=list(curves_xlab="Time", curves_ylab="Root tip angle",
                                      scat1_xlab="Angle at 30 min", scat1_ylab="Angle at 4 hrs",
                                      scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 8 hrs"))


htmlwidgets::saveWidget(theplot, file="iplotCurves.html", selfcontained=FALSE)
