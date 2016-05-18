n <- 100
p <- matrix(runif(3*n), ncol=3)
p <- p / colSums(p)
g <- sample(1:3, n, replace=TRUE)

theplot <- itriplot(p, group=g)

htmlwidgets::saveWidget(theplot, file="itriplot.html", selfcontained=FALSE)
