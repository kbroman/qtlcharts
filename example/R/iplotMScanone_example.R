# example of iplotMScanone

library(qtlcharts)

data(grav)
grav <- calc.genoprob(grav, step=1)
grav <- reduce2grid(grav)
phecol <- seq(1, nphe(grav), by=5)
out <- scanone(grav, phe=phecol, method="hk")
times <- attr(grav, "time")[phecol]
eff <- estQTLeffects(grav, phe=phecol, what="effects")

to_hrmin <-
function(times)
{
    hr <- floor(times)
    min <- round((times - hr)*60)
    if(any(min < 10))
      min[min < 10] <- paste0("0", min[min < 10])

    paste(hr, min, sep=":")
}

file <- "iplotMScanone.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize("normal")
theplot <- iplotMScanone(out, effects=eff, times=times,
                         chartOpts=list(eff_ylab="QTL effect", lod_ylab="Time (hrs)",
                                        lod_labels=to_hrmin(times),
                                        heading="<code>iplotMScanone</code>",
                                        footer=footer,
                                        caption=paste("<b><code>iplotMScanone</code> example:</b>",
                                                      "Hover over LOD heat map to view individual curves",
                                                      "below and estimated QTL effects to the right.")))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
