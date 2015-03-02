n <- 101
x <- y <- seq(-2, 2, len=n)
z <- matrix(ncol=n, nrow=n)
for(i in seq(along=x))
    for(j in seq(along=y))
        z[i,j] <- x[i]*y[j]*exp(-x[i]^2 - y[j]^2)

theplot <- iheatmap(z, x, y)

htmlwidgets::saveWidget(theplot, file="iheatmap.html", selfcontained=FALSE)
