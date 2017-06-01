# example of iplotRF

library(qtlcharts)
library(qtl)
data(badorder)
rf <- pull.rf(badorder)

file <- "iplotRF.html"
if(file.exists(file)) unlink(file)

footer <- paste(readLines("footer.txt"), collapse="\n")

qtlcharts::setScreenSize(height=800, width=1200)
theplot <- iplotRF(badorder,
                   chartOpts=list(pixelPerCell=12,
                                  heading = "<code>iplotRF</code>",
                                  caption = paste("<b><code>iplotRF</code> example:</b>",
                                                  'The heatmap displays LOD scores indicating linkage between all ',
                                                  'pairs of markers. Blue indicates large LOD with rf < 1/2; red ',
                                                  'indicates large LOD but with rf > 1/2. ',
                                                  'Click on the heatmap to view the corresponding two-locus ',
                                                  'genotype table to the right and LOD scores for selected markers, ',
                                                  'below. In the subsequent cross-tabulation on right, hover over column ',
                                                  'and row headings to view conditional distributions. In the panels below, ',
                                                  'hover over points to view marker names and click to refresh the cross-tab ',
                                                  'and lower panels with the selected marker.'),
                                  footer=footer))

htmlwidgets::saveWidget(theplot, file=file, selfcontained=TRUE)
file.rename(file, file.path("..", file))
