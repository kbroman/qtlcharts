n <- 100
g <- sample(LETTERS[1:3], n, replace=TRUE)
y <- rnorm(n, match(g, LETTERS[1:3])*10, 5)
theplot <- idotplot(g, y)

htmlwidgets::saveWidget(theplot, file="idotplot.html", selfcontained=FALSE)
