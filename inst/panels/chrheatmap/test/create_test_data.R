# create test data for chrheatmap in JSON format

library(qtl)
library(qtlcharts)
data(grav)
grav <- est.rf(grav)
lod <- pull.rf(grav, "lod")
diag(lod) <- rep(max(lod, na.rm=TRUE), nrow(lod))
mnames <- markernames(grav)
dimnames(lod) <- list(NULL, NULL)
n.mar <- nmar(grav)
names(n.mar) <- NULL
chrnam <- chrnames(grav)

library(jsonlite)
cat(jsonlite::toJSON(list(z=lod, nmar=n.mar, chr=chrnam, labels=mnames),
                     na="null"),
    file="data.json")
