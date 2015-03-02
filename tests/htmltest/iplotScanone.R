theplot <- iplotScanone(out.hk, lodcolumn=32)
htmlwidgets::saveWidget(theplot, file="iplotScanone_noeff.html", selfcontained=FALSE)

theplot <- iplotScanone(out.hk, grav, lodcolumn=32, pheno.col=32)
htmlwidgets::saveWidget(theplot, file="iplotScanone_ci.html", selfcontained=FALSE)

theplot <- iplotScanone(out.hk, grav, lodcolumn=32, pheno.col=32, pxgtype="raw")
htmlwidgets::saveWidget(theplot, file="iplotScanone_pxg.html", selfcontained=FALSE)
