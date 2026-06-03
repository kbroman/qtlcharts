# example of itriplot

library(qtlcharts)
library(broman)

# data to display
speed <- readRDS("itimeplot_data.rds")
indID <- strftime(speed$time, "%H:%m %Y-%m-%d")

file <- "iplot.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplot(speed$download, speed$upload, indID=indID,
                 chartOpts=list(xlab="Download speed (Mbps)", ylab="Upload speed (Mbps)",
                                xlim=c(0, 1000), ylim=c(0,1000),
                                margin=list(top=10, bottom=50, left=60, right=20),
                                axispos=list(xtitle=30, ytitle=55, xlabel=5, ylabel=5),
                                tipdirection="north",
                                pointcolor=crayons("Purple Pizzazz"),
                                heading="<code>iplot</code>",
                                footer=footer,
                                caption=paste("<b><code>iplot</code> example:</b>",
                                              "An interactive scatterplot; hover over",
                                              "points to see the time/date")))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
