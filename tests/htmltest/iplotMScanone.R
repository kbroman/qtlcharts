theplot <- iplotMScanone(out.hk)
htmlwidgets::saveWidget(theplot, file="iplotMScanone_noeff.html", selfcontained=FALSE)

theplot <- iplotMScanone(out.hk, grav, chartOpts=list(eff_ylab="QTL effect"))
htmlwidgets::saveWidget(theplot, file="iplotMScanone_eff.html", selfcontained=FALSE)
