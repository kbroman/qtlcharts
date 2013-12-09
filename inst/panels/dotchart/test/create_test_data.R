# create test data in JSON format

library(broman)
n <- 30
x <- sample(1:3, 30, repl=TRUE)
y <- rnorm(n, 20+x/2)
dat <- cbind(x, y)
colnames(dat) <- NULL

library(RJSONIO)
cat(RJSONIO::toJSON(dat), file="data.json")
