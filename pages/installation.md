---
layout: page
title: Installing R/qtlcharts
---

R/qtlcharts is a package for [R](http://www.r-project.org). To use it,
you first need to [download](http://cran.r-project.org/) and install
R. We also recommend the use of [RStudio](http://www.rstudio.com/),
which provides a very nice
[user interface for R](http://www.rstudio.com/products/rstudio/download/).

R/qtlcharts is early in development and is not yet available on
[CRAN](http://cran.r-project.org).

You can install R/qtlcharts from its
[GitHub repository](http://github.com/kbroman/qtlcharts). You first need to
install the [R/qtl](http://www.rqtl.org),
[jsonlite](http://cran.r-project.org/web/packages/jsonlite),
and [devtools](https://github.com/hadley/devtools) packages.

    install.packages(c("qtl", "jsonlite", "devtools"))

Then install R/qtlcharts using the `install_github` function in the
[devtools](http://github.com/hadley/devtools) package.

    library(devtools)
    install_github("kbroman/qtlcharts")

If that doesn't work, you might have an older version of devtools, so try:

    library(devtools)
    install_github("qtlcharts", "kbroman")
