# create test data in JSON format

set.seed(27806353)
# simulate MVN data
V <- rbind(c(1, 0.5*2, 0.2*3),
           c(0.5*2, 4, 0.8*3*2),
           c(0.2*3, 0.8*3*2, 9))
D <- chol(V)
mu <- c(2, 5, 10)
p <- length(mu)
n <- 200
dat <- matrix(rnorm(n*p), ncol=p) %*% D +
  rep(mu, rep(n,p))

dat[1:4,3] <- NA
dat[4:9,2] <- NA

library(jsonlite)
cat(jsonlite::toJSON(dat), file="data.json")
