# nice example of iboxplot

library(qtlcharts)

# data from Alan Attie and colleagues, Biochemistry, University of Wisconsin-Madison
load("iboxplot_data.RData")
exdat <- exdat/1000
med <- apply(exdat, 1, median, na.rm=TRUE)
exdat <- exdat[order(med, decreasing=TRUE),]

# remove the target file, if it exists
file <- "../iboxplot.html"
if(file.exists(file)) unlink(file)

# onefile=TRUE makes the resulting html file all-inclusive (javascript + css + data)
#     this is a bit wasteful of space, but it's easy
iboxplot(exdat, title="iboxplot example", chartOpts=list(xlab="Mice", ylab="Gene expression"),
         orderByMedian=FALSE, onefile=TRUE, openfile=FALSE, file=file,
         qu=c(0.01, 0.1, 0.25),
         caption=c("The top panel is like a set of 494 box plots: lines are drawn at a series ",
           "of percentiles for each of the distributions. Hover over a column in the top panel ",
           "and the corresponding distribution is show below; click for it to persist; click ",
           "again to make it go away.<br><br>\n",
           "</p><hr/><p class=\"caption\"><a style=\"text-decoration:none;\" href=\"http://kbroman.org/qtlcharts\">R/qtlcharts</a>"))
