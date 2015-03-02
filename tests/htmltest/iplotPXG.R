theplot <- iplotPXG(grav, marker="BF.206L-Col", pheno.col="T320")

htmlwidgets::saveWidget(theplot, file="iplotPXG.html", selfcontained=FALSE)
