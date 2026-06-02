# itimemap example

library(qtlcharts)
library(glue)

# data to display
speed <- readRDS("itimeplot_data.rds")
indID <- glue('{round(speed$download)} Mbps ({strftime(speed$time, "%H:%m %Y-%m-%d")})')

# remove the target file, if it exists
file <- "itimeplot.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- itimeplot(speed$time, speed$download, indID=indID,
                     chartOpts=list(heading = "<code>itimeplot</code>",
                                    xlab="Date", ylab="Download speed (Mbps)",
                                    caption=paste("<b><code>itimeplot</code> example:</b>",
                                                  "Hover over points in the plot to see the date/time and value."),
                                    footer=footer, ylim=c(0,1000),
                                    axispos=list(xtitle=25, ytitle=35, xlabel=5, ylabel=5)))
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
