
context("chartOpts")

tmpf <- function(opts, digits=2) toJSON(opts4json(opts), digits=digits)
addquotes <- function(x) paste0("\"", x, "\"")


test_that("conversion of chartOpts to JSON", {

  expect_equal(tmpf(NULL), "null")

  input01 <- c(xlab="x axis label", ylab="y axis label")
  output01 <- paste("{", paste(addquotes(names(input01)), ":", addquotes(input01), collapse=", "), "}")
  expect_equal(tmpf(input01), output01)

  input02 <- list(xlab="x axis label", ylab="y axis label")
  output02 <- output01
  expect_equal(tmpf(input02), output02)

  input03 <- list(xlab="x axis label", ylab="y axis label", zlab=NULL, margins=list(left=2, right=50))
  output03 <- "{ \"xlab\" : \"x axis label\", \"ylab\" : \"y axis label\", \"zlab\" : null, \"margins\" : { \"left\" : 2, \"right\" : 50 } }"
  expect_equal(tmpf(input03), output03)

})

test_that("use of add2chartOpts", {

  input04 <- list(x="x", y="y")
  input04 <- add2chartOpts(input04, chartdivid="chart")
  output04 <- "{ \"x\" : \"x\", \"y\" : \"y\", \"chartdivid\" : \"chart\" }"
  expect_equal(tmpf(input04), output04)

  input05 <- c(x="x", y="y")
  input05 <- add2chartOpts(input05, chartdivid="chart")
  output05 <- output04
  expect_equal(tmpf(input05), output05)

  input06 <- list(x="x", y="y")
  input06 <- add2chartOpts(input06, title="blah", chartdivid="chart")
  output06 <- "{ \"x\" : \"x\", \"y\" : \"y\", \"title\" : \"blah\", \"chartdivid\" : \"chart\" }"
  expect_equal(tmpf(input06), output06)

  input07 <- c(x="x", y="y")
  input07 <- add2chartOpts(input07, title="blah", chartdivid="chart")
  output07 <- output06
  expect_equal(tmpf(input07), output07)

})

test_that("small things", {

  input08 <- list(x="a", y=NA)
  output08 <- "{ \"x\" : \"a\", \"y\" : null }"
  expect_equal(tmpf(input08), output08)

  input09 <- list(x=NA, y="a")
  output09 <- "{ \"x\" : null, \"y\" : \"a\" }"
  expect_equal(tmpf(input09), output09)

  input10 <- list(x=1, y=NA)
  output10 <- "{ \"x\" : 1, \"y\" : null }"
  expect_equal(tmpf(input10), output10)

  input11 <- list(x=NA, y=1)
  output11 <- "{ \"x\" : null, \"y\" : 1 }"
  expect_equal(tmpf(input11), output11)

  input12 <- c(x="a", y=NA)
  output12 <- output08
  expect_equal(tmpf(input12), output12)

  input13 <- c(x=NA, y="a")
  output13 <- output09
  expect_equal(tmpf(input13), output13)

  input14 <- c(x=1, y=NA)
  output14 <- "{ \"x\" : 1, \"y\" : \"NA\" }"
  expect_equal(tmpf(input14), output14)

  input15 <- c(x=NA, y=1)
  output15 <- "{ \"x\" : \"NA\", \"y\" : 1 }"
  expect_equal(tmpf(input15), output15)

})

