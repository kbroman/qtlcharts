# example of scat2scat

library(qtlcharts)

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

footer <- paste(readLines("footer.txt"), collapse="\n")

# plot it and save to file
qtlcharts::setScreenSize("normal")
theplot <- scat2scat(scat1, scat2,
                     chartOpts=list(ylab1="correlation",
                                    axispos=list(xtitle=25, ytitle=35, xlabel=5, ylabel=5),
                                    heading="<code>scat2scat</code>",
                                    caption=paste("<b><code>scat2scat</code> example:</b>",
                                                  "The scatterplot on the left is of two summary statistics for other scatterplots.",
                                                  "That is, each point corresponds to a scatterplot between two variables.",
                                                  "Click on a point to view the corresponding scatterplot on the right."),
                                    footer=footer),
                                    digits=3)
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
