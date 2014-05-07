
context("chartOpts")

tmpf <- function(opts, digits=2) toJSON( opts4json(opts), digits=digits)
addquotes <- function(x) paste0("\"", x, "\"")


test_that("conversion of chartOpts to JSON", {

  expect_equal( tmpf(NULL), "null")

  input01 <- c(xlab="x axis label", ylab="y axis label")
  output01 <- paste("{", paste(addquotes(names(input01)), ":", addquotes(input01), collapse=", "), "}")
  expect_equal( tmpf(input01), output01 )

  input02 <- list(xlab="x axis label", ylab="y axis label")
  output02 <- output01
  expect_equal( tmpf(input02), output02 )

  input03 <- list(xlab="x axis label", ylab="y axis label", zlab=NULL, margins=list(left=2, right=50))
  output03 <- "{ \"xlab\" : \"x axis label\", \"ylab\" : \"y axis label\", \"zlab\" : null, \"margins\" : { \"left\" : 2, \"right\" : 50 } }"  
  expect_equal( tmpf(input03), output03 )

})

test_that("convert simple things to JSON", {

  input04 <- list(x="a", y=NA)
  output04 <- "{ \"x\" : \"a\", \"y\" : null }"
  expect_equal( tmpf(input04), output04 )

  input05 <- list(x=NA, y="a")
  output05 <- "{ \"x\" : null, \"y\" : \"a\" }"
  expect_equal( tmpf(input05), output05 )

  input06 <- list(x=NA, y=1)
  output06 <- "{ \"x\" : null, \"y\" : 1 }"
  expect_equal( tmpf(input06), output06 )

  input07 <- list(x=1, y=NA)
  output07 <- "{ \"x\" : 1, \"y\" : null }"
  expect_equal( tmpf(input07), output07 )

  input08 <- c(x="a", y=NA)
  output08 <- "{ \"x\" : \"a\", \"y\" : null }"
  expect_equal( tmpf(input08), output08 )

  input09 <- c(x=NA, y="a")
  output09 <- "{ \"x\" : null, \"y\" : \"a\" }"
  expect_equal( tmpf(input09), output09 )

  input10 <- c(x=1, y=NA)
  output10 <- "{ \"x\" : 1, \"y\" : \"NA\" }"
  expect_equal( tmpf(input10), output10 )

  input11 <- c(x=NA, y=1)
  output11 <- "{ \"x\" : \"NA\", \"y\" : 1 }"
  expect_equal( tmpf(input11), output11 )

  # I don't understand this NA -> "NA" if numeric and null if character
  expect_equal( toJSON(lapply(c(a=1,   b=NA), unbox)), "{ \"a\" : 1, \"b\" : \"NA\" }")
  expect_equal( toJSON(lapply(c(a="1", b=NA), unbox)), "{ \"a\" : \"1\", \"b\" : null }")

})

test_that("More tests of chartOpts to JSON", {

  input12 <- list(x="x", y="y")
  input12 <- add2chartOpts(input12, chartdivid="chart")
  output12 <- "{ \"x\" : \"x\", \"y\" : \"y\", \"chartdivid\" : \"chart\" }"
  expect_equal( tmpf(input12), output12)

  input13 <- c(x="x", y="y")
  input13 <- add2chartOpts(input13, chartdivid="chart")
  output13 <- output12
  expect_equal( tmpf(input13), output13)

  input14 <- list(x="x", y="y")
  input14 <- add2chartOpts(input14, title="blah", chartdivid="chart")
  output14 <- "{ \"x\" : \"x\", \"y\" : \"y\", \"title\" : \"blah\", \"chartdivid\" : \"chart\" }"
  expect_equal( tmpf(input14), output14)

  input15 <- c(x="x", y="y")
  input15 <- add2chartOpts(input15, title="blah", chartdivid="chart")
  output15 <- output14
  expect_equal( tmpf(input15), output15)
})
