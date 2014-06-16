---
layout: page
title: Installing R/qtlcharts
---

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
