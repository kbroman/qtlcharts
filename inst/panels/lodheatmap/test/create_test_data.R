# create test data in JSON format

library(qtlcharts)
data(grav)
grav <- calc.genoprob(grav, step=2)
out <- scanone(grav, method="hk", phe=seq(1, 241, by=20))
cat(qtlcharts:::scanone2json(out), file="data.json")
