# create test data in JSON format

library(qtlcharts)
data(grav)
grav <- reduce2grid(calc.genoprob(grav, step=2))

grav$pheno <- grav$pheno[,seq(1, nphe(grav), by=5)]
out <- scanone(grav, method="hk", phe=1:nphe(grav))

p <- pull.genoprob(grav, omit.first.prob=TRUE)
eff <- t(apply(p, 2, function(x, y) lm(y~x)$coef[2,], as.matrix(grav$pheno)))

# convert to signed LOD scores
out[,-(1:2)] <- out[,-(1:2)] * ((eff > 0)*2-1)

cat(qtlcharts:::scanone2json(out), file="data.json")
