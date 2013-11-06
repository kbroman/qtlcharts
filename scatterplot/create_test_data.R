# create test data in JSON format

library(broman)
dat <- rmvn(200, c(2, 5, 10),
            rbind(c(1, 0.5*2, 0.2*3), 
                  c(0.5*2, 4, 0.8*3*2),
                  c(0.2*3, 0.8*3*2, 9)))

library(RJSONIO)
cat(toJSON(dat), file="data.json")
