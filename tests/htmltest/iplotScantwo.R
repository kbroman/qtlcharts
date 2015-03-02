grav <- calc.genoprob(grav, step=5)
out2 <- scantwo(grav, pheno.col=32, method="hk", verbose=FALSE)

theplot <- iplotScantwo(out2)
htmlwidgets::saveWidget(theplot, file="iplotScantwo_noeff.html", selfcontained=FALSE)

theplot <- iplotScantwo(out2, grav, pheno.col=32)
htmlwidgets::saveWidget(theplot, file="iplotScantwo_eff.html", selfcontained=FALSE)
