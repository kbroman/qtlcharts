
context("group2numeric")

test_that("groups2numeric works properly", {

  x <- c(2, 3, 2, 1, 4, 3, 2, 4, 1, 1)
  expect_equal(group2numeric(x), x)

  y <- c("A","B","C","D")[x]
  expect_equal(group2numeric(y), x)

  expect_equal(group2numeric(as.factor(x)), x)

  expect_equal(group2numeric(as.factor(y)), x)

  expect_equal(group2numeric(x+5), x)

  expect_equal(group2numeric(as.factor(x+5)), x)
})
