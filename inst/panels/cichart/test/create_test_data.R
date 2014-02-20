# create test data in JSON format

set.seed(53079239)
n <- 300
k <- 3
x <- sample(1:k, n, replace=TRUE)
y <- rnorm(n, 20+x)
means <- as.numeric(tapply(y, x, mean))
lo <- as.numeric(tapply(y, x, function(a) t.test(a)$conf.int[1]))
hi <- as.numeric(tapply(y, x, function(a) t.test(a)$conf.int[2]))

dat <- list(means=means,
            low=lo,
            high=hi,
            categories=paste0(1:k))

library(RJSONIO)
cat(RJSONIO::toJSON(dat), file="data.json")
