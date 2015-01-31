# create test data in JSON format

library(qtl)
library(qtlcharts)
data(hyper)
map <- pull.map(hyper)

cat(qtlcharts:::map2json(map), file="data.json")
