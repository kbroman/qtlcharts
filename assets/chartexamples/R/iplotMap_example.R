# example of iplotMap

library(qtlcharts)
data(hyper)
map <- pull.map(hyper)

file <- "../iplotMap_example.html"
if(file.exists(file)) unlink(file)

iplotMap(map, shift=TRUE, title="iplotMap example",
          onefile=TRUE, openfile=FALSE, file=file)
