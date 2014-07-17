
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

test_that("calcSignedLOD works", {

    scanout <- data.frame(chr=c("1", "2", "3"), pos=rep(0,3),
                          lod1=1:3, lod2=4:6, lod3=7:9)
    class(scanout) <- c("scanone", "data.frame")

    eff <- list(cbind("a"=c(1, -1,  0.0), "d"=c(0, 1, 0)),
                cbind("a"=c(-1, 1, -0.2)),
                cbind("a"=c(1, -1,  0.2)))

    signedscanout <- data.frame(chr=c("1", "2", "3"), pos=rep(0,3),
                                lod1=c(1,-2,3), lod2=c(-4,5,-6), lod3=c(7,-8,9))
    class(signedscanout) <- c("scanone", "data.frame")

    expect_equal( calcSignedLOD(scanout, eff), signedscanout )

})

test_that("strip_whitespace works", {

    input <- "This is some text:\"blah blah blah\tblah\"\tAnd here is more:\t \"blah blah\"."
    output <- "Thisissometext:\"blah blah blah\tblah\"Andhereismore:\"blah blah\"."
    expect_equal(strip_whitespace(input), output)

    opt <- list(xlab="x-axis label", ylab="y-axis label")
    json <- strip_whitespace(toJSON(opt))
    output <- "{\"xlab\":[\"x-axis label\"],\"ylab\":[\"y-axis label\"]}"
    expect_equal(json, output)

    opt <- list(xlab='x-axis label', ylab='y-axis label')
    json <- strip_whitespace(toJSON(opt))
    output <- "{\"xlab\":[\"x-axis label\"],\"ylab\":[\"y-axis label\"]}"
    expect_equal(json, output)

    opt <- list(xlab="x-axis label", ylab="y-axis label")
    json <- strip_whitespace(toJSON(opts4json(opt)))
    output <- "{\"xlab\":\"x-axis label\",\"ylab\":\"y-axis label\"}"
    expect_equal(json, output)

    opt <- list(xlab='x-axis label', ylab='y-axis label')
    json <- strip_whitespace(toJSON(opts4json(opt)))
    output <- "{\"xlab\":\"x-axis label\",\"ylab\":\"y-axis label\"}"
    expect_equal(json, output)

    opt <- c(xlab="Don't try this at home", ylab="y-axis label")
    json <- toJSON(opts4json(opt))
    output <- "{\"xlab\":\"Don't try this at home\",\"ylab\":\"y-axis label\"}"
    expect_equal(strip_whitespace(json), output)

    opt <- c(xlab="Don't try this at home", ylab="Don't try this either")
    json <- toJSON(opts4json(opt))
    output <- "{\"xlab\":\"Don't try this at home\",\"ylab\":\"Don't try this either\"}"
    expect_equal(strip_whitespace(json), output)

    # things get messed up with nested double-quotes, or use of single-quotes
    input <- "Can't use single quotes, like this 'blah blah blah'"
    output <- "Can'tusesinglequotes,likethis'blahblahblah'"
    expect_equal(strip_whitespace(input), output)

    opt <- c(xlab="Can't use \"double-quotes\".", ylab="blah")
    json <- toJSON(opts4json(opt))
    output <- "{\"xlab\":\"Can't use \\\"double-quotes\\\".\",\"ylab\":\"blah\"}"
    expect_equal(strip_whitespace(json), output)

})

test_that("test is_equally_spaced", {

    x <- seq(0, 8, length=241)
    expect_true( is_equally_spaced(x) )

    x <- 1:10
    expect_true( is_equally_spaced(x) )

    x <- c(1, 3, 4, 5)
    expect_false( is_equally_spaced(x) )

    x <- c(1, 3, 2, 4, 5)
    expect_warning( result <- is_equally_spaced(x), "vector is not monotonic")
    expect_false(result)

    x <- c(1, 3, NA, 4, 5)
    expect_warning( result <- is_equally_spaced(x), "vector contains missing values")
    expect_false(result)

    expect_warning( result <- is_equally_spaced(1), "vector has length < 2")
    expect_false(result)

    expect_warning( result <- is_equally_spaced(NULL), "vector has length < 2")
    expect_false(result)

    expect_warning( result <- is_equally_spaced(c("a", "b", "c")), "vector is not numeric")
    expect_false(result)

})
