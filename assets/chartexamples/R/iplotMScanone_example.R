# example of iplotMScanone

library(qtlcharts)

data(grav)
grav <- calc.genoprob(grav, step=1)
grav <- reduce2grid(grav)
out <- scanone(grav, phe=seq(1, nphe(grav), by=5), method="hk")
eff <- estQTLeffects(grav, phe=seq(1, nphe(grav), by=5), what="effects")

file <- "../iplotMScanone_example.html"
if(file.exists(file)) unlink(file)

iplotMScanone(out, effects=eff, title="iplotMScanone example, with effects",
              chartOpts=list(eff_ylab="QTL effect"),
              onefile=TRUE, openfile=FALSE, file=file,
              caption=c("Hover over LOD heat map to view individual curves ",
                "below and estimated QTL effects to the right.<br><br>\n",
                "[<a style=\"text-decoration:none;\" href=\"http://kbroman.github.io/qtlcharts\">Main page</a>]"))
