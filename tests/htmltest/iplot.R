rowmedian <- apply(grav$pheno, 1, median, na.rm=TRUE)
grp <- as.numeric(rowmedian < median(unlist(grav$pheno), na.rm=TRUE))+1
theplot <- iplot(grav$pheno$T0, grav$pheno$T60,
                 group=grp,
                 indID=paste0("RIL", 1:nind(grav)),
                 chartOpts=list(xlab="Angle at time 0", ylab="Angle at 60 min"))

htmlwidgets::saveWidget(theplot, file="iplot.html", selfcontained=FALSE)
