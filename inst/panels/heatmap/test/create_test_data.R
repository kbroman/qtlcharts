# create test data in JSON format

n <- 101
x <- y <- seq(-pi, pi, len=n)
z <- matrix(ncol=n, nrow=n)
for(i in seq(along=x))
    for(j in seq(along=y))
        z[i,j] <- sin(x[i]) + cos(y[j])

library(jsonlite)
cat(jsonlite::toJSON(list(x=x, y=y, z=z)),
    file="data.json")
