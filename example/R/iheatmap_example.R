# iheatmap example

library(qtlcharts)

# data to display
n <- 101
x <- y <- seq(-2, 2, len=n)
z <- matrix(ncol=n, nrow=n)
for(i in seq(along=x))
  for(j in seq(along=y))
    z[i,j] <- x[i]*y[j]*exp(-x[i]^2 - y[j]^2)

# Example function from Dmitry Pelinovsky
# http://dmpeli.mcmaster.ca/Matlab/Math1J03/LectureNotes/Lecture2_5.htm

# remove the target file, if it exists
file <- "iheatmap.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iheatmap(z, x, y, chartOpts=list(heading = "<code>iheatmap</code>",
                                            caption=paste("<b><code>iheatmap</code> example:</b>",
                                                          "Hover over pixels in the heatmap on the top-left to see the values",
                                                          "and to see the horizontal slice (below) and the vertical slice (to the right)."),
                                            footer=footer))
htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
