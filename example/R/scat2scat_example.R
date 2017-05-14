# example of scat2scat

library(qtlcharts)
library(qtl)

# simulate some data
p <- 100
n <- 300
SD <- runif(p, 1, 5)
r <- runif(p, -1, 1)
scat2 <- vector("list", p)
for(i in 1:p)
    scat2[[i]] <- matrix(rnorm(2*n), ncol=2) %*% chol(SD[i]^2*matrix(c(1, r[i], r[i], 1), ncol=2))
scat1 <- cbind(SD=SD, r=r)

file <- "scat2scat.html"
if(file.exists(file)) unlink(file)

# plot it and save to file
theplot <- scat2scat(scat1, scat2, chartOpts=list(title="scat2scat example"), digits=3)
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
