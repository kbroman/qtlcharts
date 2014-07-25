# example of iplotRF

library(qtlcharts)
data(badorder)
rf <- pull.rf(badorder)

file <- "../iplotRF.html"
if(file.exists(file)) unlink(file)

iplotRF(badorder, title="iplotRF example",
        onefile=TRUE, openfile=FALSE, file=file,
        chartOpts=list(pixelPerCell=12))
