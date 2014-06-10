
context("json i/o")

test_that("test simple conversions to JSON", {
  tocharjson <- function(...) as.character(toJSON(...))


  input01 <- list(x="a", y=NA)
  output01 <- "{\"x\":[\"a\"],\"y\":[null]}"
  expect_equal(tocharjson(input01), output01)

  input02 <- list(x=NA, y="a")
  output02 <- "{\"x\":[null],\"y\":[\"a\"]}"
  expect_equal(tocharjson(input02), output02)

  input03 <- list(x=NA, y=1)
  output03 <- "{\"x\":[null],\"y\":[1]}"
  expect_equal(tocharjson(input03), output03)

  input04 <- list(x=1, y=NA)
  output04 <- "{\"x\":[1],\"y\":[null]}"
  expect_equal(tocharjson(input04), output04)

  input05 <- c(x="a", y=NA)
  output05 <- "[\"a\",null]"
  expect_equal(tocharjson(input05), output05)

  input06 <- c(x=NA, y="a")
  output06 <- "[null,\"a\"]"
  expect_equal(tocharjson(input06), output06)

  input07 <- c(x=1, y=NA)
  output07 <- "[1,\"NA\"]"
  expect_equal(tocharjson(input07), output07)

  input08 <- c(x=NA, y=1)
  output08 <- "[\"NA\",1]"
  expect_equal(tocharjson(input08), output08)

  # It's a bit of a surprise that NA -> "NA" if numeric and NA -> null if character
  expect_equal(tocharjson(lapply(c(a=1,   b=NA), unbox)), "{\"a\":1,\"b\":\"NA\"}")
  expect_equal(tocharjson(lapply(c(a="1", b=NA), unbox)), "{\"a\":\"1\",\"b\":null}")

})

