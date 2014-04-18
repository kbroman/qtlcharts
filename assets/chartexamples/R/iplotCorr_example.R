# example of iplotCorr

library(qtlcharts)
data(geneExpr)

file <- "../iplotCorr_example.html"
if(file.exists(file)) unlink(file)

iplotCorr(geneExpr$expr, geneExpr$genotype, title = "iplotCorr example",
          chartOpts=list(cortitle="Correlation matrix",
            scattitle="Scatterplot"),
          onefile=TRUE, openfile=FALSE, file=file,
          caption=c("The left panel is an image of a correlation matrix, with ",
            "blue = -1 and red = +1. Hover over pixels in the correlation matrix ",
            "on the left to see the values; click to see the corresponding ",
            "scatterplot on the right.<br><br>\n",
            "[<a style=\"text-decoration:none;\" href=\"http://kbroman.github.io/qtlcharts\">Main page</a>]"))
