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
file <- "../iheatmap_example.html"
if(file.exists(file)) unlink(file)

# onefile=TRUE makes the resulting html file all-inclusive (javascript + css + data)
#     this is a bit wasteful of space, but it's easy
iheatmap(z, x, y, title = "iheatmap example", onefile=TRUE, openfile=FALSE,
         file=file,
         caption=c("Hover over pixels in the heatmap on the top-left to see the values ",
           "and to see the horizontal slice (below) and the vertical slice (to the right).<br><br>\n",
           "[<a style=\"text-decoration:none;\" href=\"http://kbroman.org/qtlcharts\">Main page</a>]"))
