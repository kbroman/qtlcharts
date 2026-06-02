n_pts <- 100
x <-  seq(as.POSIXct("1969-05-01"), as.POSIXct("1969-05-04"), length=n_pts)
grp <- sample(1:3, n_pts, replace=TRUE)
y <- rnorm(n_pts, grp) + rnorm(n_pts)
theplot <- itimeplot(x, y, grp)

htmlwidgets::saveWidget(theplot, file="itimeplot.html", selfcontained=FALSE)
