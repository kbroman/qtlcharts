# create test data for crosstab in JSON format

# example data set
library(qtl)
data(fake.f2)

# select first two markers from each of chr 1 and X
mar <- c(markernames(fake.f2, chr=1)[1:2],
         markernames(fake.f2, chr="X")[1:2])

# subset to just these markers
fake.f2 <- pull.markers(fake.f2, mar)

# write to data file
cat(qtlcharts:::convert4crosstab(fake.f2), file="data.json")
