# create test data in JSON format

set.seed(27806353)

# random growth curves, based on some data
times <- 1:16
n <- 100
start <- rnorm(n, 5.2, 0.8)
slope1to5 <- rnorm(n, 2.6, 0.5)
slope5to16 <- rnorm(n, 0.24 + 0.09*slope1to5, 0.195)
y <- matrix(ncol=16, nrow=n)
y[,1] <- start
for(j in 2:5)
    y[,j] <- y[,j-1] + slope1to5
for(j in 6:16)
    y[,j] <- y[,j-1] + slope5to16
y <- y + rnorm(prod(dim(y)), 0, 0.35)

# simulate some missing data
mis <- sample(n, 10)
for(i in mis)
    y[i,!rbinom(16, 1, 0.8)] <- NA

# group = 1/2 (e.g. sex)
means <- rowMeans(y, na.rm=TRUE)
means <- means - min(means)
group <- rbinom(n, 1, prob=means/max(means))+1

dat <- list(x=times, data=y, group=group)

library(jsonlite)
cat(jsonlite::toJSON(dat, na="null"), file="data.json")
