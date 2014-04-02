# example of iplotCorr

library(qtlcharts)
data(geneExpr)

file <- "../iplotCorr_example.html"
if(file.exists(file)) unlink(file)

iplotCorr(geneExpr$expr, geneExpr$genotype, title = "iplotCorr example",
          chartOpts=list(cortitle="Correlation matrix",
            scattitle="Scatterplot"),
          onefile=TRUE, openfile=FALSE, file=file)
