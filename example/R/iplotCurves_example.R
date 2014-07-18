# example of iplotCurves

library(qtlcharts)

data(grav)
times <- attr(grav, "time")
phe <- grav$pheno
wh <- seq(1, length(times), by=2)
times <- times[wh]
phe <- phe[,wh]

file <- "../iplotCurves.html"
if(file.exists(file)) unlink(file)

iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
            title="iplotCurves example",
            chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Root tip angle (degrees)",
              scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
              scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"),
            onefile=TRUE, openfile=FALSE, file=file,
            caption=c("The curves are linked to the two scatterplots below: hover over an ",
              "element in one panel, and the corresponding elements in the other panels will ",
              "be highlighted.<br><br>\n",
              "</p><hr/><p class=\"caption\"><a style=\"text-decoration:none;\" href=\"http://kbroman.org/qtlcharts\">R/qtlcharts</a>"))
