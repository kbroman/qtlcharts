context("chartOpts")

test_that("add2chartOpts works correctly", {

    # adding something to a NULL
    expect_equal(list(height=500), add2chartOpts(NULL, height=500))

    # adding two things to a NULL
    expect_equal(list(height=500, width=1000),
                 add2chartOpts(NULL, height=500, width=1000))

    # adding something to a list
    expect_equal(list(title="title", xlab="xlab", height=300),
                 add2chartOpts(list(title="title", xlab="xlab"), height=300))

    # adding two things to a list
    expect_equal(list(title="title", xlab="xlab", height=300, width=600),
                 add2chartOpts(list(title="title", xlab="xlab"), height=300, width=600))

    # adding something that's already there
    expect_equal(list(title="title", height=300),
                 add2chartOpts(list(title="title", height=300), height=600))
    expect_equal(list(height=300, title="title"),
                 add2chartOpts(list(height=300, title="title"), height=600))
    expect_equal(list(title="title", height=300, width=500),
                 add2chartOpts(list(title="title", height=300), height=600, width=500))
    expect_equal(list(height=300, title="title", width=500),
                 add2chartOpts(list(height=300, title="title"), width=500, height=600))

    # adding two things that are already there
    expect_equal(list(title="title", height=300, width=500),
                 add2chartOpts(list(title="title", height=300, width=500), height=600, width=1000))
    expect_equal(list(title="title", height=300, width=500),
                 add2chartOpts(list(title="title", height=300, width=500), width=1000, height=600))
    expect_equal(list(title="title", height=300, width=500, xlab="xlab"),
                 add2chartOpts(list(title="title", height=300, width=500),
                               height=600, width=1000, xlab="xlab"))


})
