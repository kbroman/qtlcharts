
context("chartOpts")

test_that("conversion of chartOpts to JSON", {

  tmpf <- function(opts, digits=2) toJSON( opts4json(opts), digits=digits)
  addquotes <- function(x) paste0("\"", x, "\"")

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

