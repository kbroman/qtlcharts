# example of iplotMap

library(qtlcharts)
data(hyper)
map <- pull.map(hyper)

file <- "../iplotMap.html"
if(file.exists(file)) unlink(file)

iplotMap(map, shift=TRUE, title="iplotMap example",
         onefile=TRUE, openfile=FALSE, file=file)
cat('<hr/><p class="caption"><a style="text-decoration:none;" href="http://kbroman.org/qtlcharts">R/qtlcharts</a></p>',
    file=file, append=TRUE)
