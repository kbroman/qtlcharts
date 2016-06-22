context("group2numeric")

test_that("groups2numeric works properly", {

    x <- c(2, 3, 2, 1, 4, 3, 2, 4, 1, 1)
    expect_equal(group2numeric(x), x)

    y <- c("A","B","C","D")[x]
    expect_equal(group2numeric(y), x)

    expect_equal(group2numeric(as.factor(x)), x)

    expect_equal(group2numeric(as.factor(y)), x)

    # leaves numeric values unchanged
    expect_equal(group2numeric(x+5), x+5)

    # shifts factors to numeric
    expect_equal(group2numeric(as.factor(x+5)), x)

    # treatment of NAs
    x[4] <- NA
    expected <- x;expected[4] <- 5
    expect_equal(group2numeric(x), expected)

    expect_equal(group2numeric(x, preserveNA=TRUE), x)
    expect_equal(group2numeric(x+5, preserveNA=TRUE), x+5)
    expect_equal(group2numeric(as.factor(x+5), preserveNA=TRUE), x)
})
