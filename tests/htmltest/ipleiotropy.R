theplot <- ipleiotropy(grav, out.hk, pheno.col=c(32, 49), lodcolumn=c(32, 49), chr=1)
htmlwidgets::saveWidget(theplot, file="ipleiotropy.html", selfcontained=FALSE)

theplot_nolod <- ipleiotropy(grav, pheno.col=c(32, 49), chr=1)
htmlwidgets::saveWidget(theplot_nolod, file="ipleiotropy_nolod.html", selfcontained=FALSE)

theplot_interval <- ipleiotropy(grav, out.hk, lodcolumn=1:2, pheno.col=c(32, 49), chr=1,
                                interval=c(53,68))
htmlwidgets::saveWidget(theplot_interval, file="ipleiotropy_interval.html", selfcontained=FALSE)
