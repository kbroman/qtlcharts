# example of itriplot

library(qtlcharts)
library(qtl)
library(qtlbook)
data(gutlength)
g <- pull.geno(fill.geno(gutlength), chr=1:19)
gf <- apply(g, 1, function(a) table(factor(a, levels=1:3)))
gf <- gf+runif(prod(dim(gf)), 0, 0.1) # add a bit of jitter
p <- t(gf)/colSums(gf)
colnames(p) <- c("CC", "CB", "BB")

file <- "itriplot.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- itriplot(p,
                    chartOpts=list(heading="<code>itriplot</code>",
                                   footer=footer,
                                   caption=paste("<b><code>itriplot</code> example:</b>",
                                                 "A representation of trinomial distributions;",
                                                 "the points show the genotype frequencies",
                                                 "in different mice. The three frequencies",
                                                 "are the distances from the point to each",
                                                 "of the three sides of the triangle.")))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
