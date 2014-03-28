
context("utililities")

test_that("select phenotype columns works on small cases", {

  data(grav)
  phe <- phenames(grav)

  expect_equal( getPhename(grav, "T0"), "T0" )
  expect_equal( getPhename(grav, 1), "T0" )
  expect_equal( getPhename(grav, c(2, 5, 20)), phe[c(2,5,20)] )
  expect_equal( getPhename(grav, -(5:nphe(grav))), phe[1:4] )

})

test_that("selectMatrixColumns works with small cases", {

  n <- 5
  mat <- matrix(ncol=n, nrow=2)
  colnames(mat) <- paste0("col", 1:n)

  expect_equal( selectMatrixColumns(mat, "col1"), 1 )
  expect_equal( selectMatrixColumns(mat, c("col4", "col2")), c(4,2) )
  expect_equal( selectMatrixColumns(mat, colnames(mat)), 1:5 )

})

test_that("grabarg works in simple cases", {

  expect_equal( grabarg(list(map.function="c-f"), "method", "imp"), "imp" )
  expect_equal( grabarg(list(method="argmax", map.function="c-f"), "method", "imp"), "argmax" )

})
