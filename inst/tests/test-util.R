
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

test_that("extractPheno works", {

  data(grav)
  expect_equivalent( extractPheno(grav, 1), as.matrix(grav$pheno[,1,drop=FALSE]) )
  expect_equivalent( extractPheno(grav, c(1, 5, 241)), as.matrix(grav$pheno[,c(1, 5, 241),drop=FALSE]) )

  expect_equivalent( extractPheno(grav, "T0"), as.matrix(grav$pheno[,"T0",drop=FALSE]) )
  expect_equivalent( extractPheno(grav, c("T0", "T10", "T480")), as.matrix(grav$pheno[,c("T0", "T10", "T480"),drop=FALSE]) )

  # vector of phenotypes
  x <- rnorm(nind(grav))
  expect_equivalent( extractPheno(grav, x), cbind(x) )

  # matrix of phenotypes
  x <- matrix(rnorm(nind(grav)*10), ncol=10)
  expect_equivalent( extractPheno(grav, x), x )

  expect_error( extractPheno(grav, "blah") )
  expect_error( extractPheno(grav, 0) )
  expect_error( extractPheno(grav, c(-1, 5)) )

  # negative indices
  expect_equivalent( extractPheno(grav, -(11:20)), as.matrix(grav$pheno[,-(11:20),drop=FALSE]) )

  # logical values
  expect_equivalent( extractPheno(grav, qtl::phenames(grav) == "T240"), as.matrix(grav$pheno[,"T240",drop=FALSE]) )

})
