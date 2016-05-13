set.seed(69891250)
p <- 500
n <- 300
SD <- runif(p, 1, 5)
r <- runif(p, -1, 1)
scat2 <- vector("list", p)
for(i in 1:p)
   scat2[[i]] <- matrix(rnorm(2*n), ncol=2) %*% chol(SD[i]^2*matrix(c(1, r[i], r[i], 1), ncol=2))
scat1 <- cbind(SD=SD, r=r)

theplot <- scat2scat(scat1, scat2, chartOpts=list(width=1000, height=500))
htmlwidgets::saveWidget(theplot, file="scat2scat.html", selfcontained=FALSE)
