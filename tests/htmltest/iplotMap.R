theplot <- iplotMap(grav)

htmlwidgets::saveWidget(theplot, file="iplotMap.html", selfcontained=FALSE)
