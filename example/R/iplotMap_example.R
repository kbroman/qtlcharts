# example of iplotMap

library(qtlcharts)
data(hyper)
map <- pull.map(hyper)

file <- "../iplotMap.html"
if(file.exists(file)) unlink(file)

iplotMap(map, shift=TRUE, title="iplotMap example",
         onefile=TRUE, openfile=FALSE, file=file,
         caption=c("Hover over marker positions to view the marker names.<br><br>\n",
                   "</p><hr/><p class=\"caption\"><a style=\"text-decoration:none;\" href=\"http://kbroman.org/qtlcharts\">R/qtlcharts</a>"))
