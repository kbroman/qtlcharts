---
layout: page
title: Installing R/qtlcharts
description: Instructions on how to install the R/qtlcharts package.
---

R/qtlcharts is a package for [R](https://www.r-project.org). To use it,
you first need to [download](https://cran.r-project.org/) and install
R. We also recommend the use of [RStudio](https://www.rstudio.com/),
which provides a very nice
[user interface for R](https://www.rstudio.com/products/rstudio/download/).

Install R/qtlcharts from CRAN using

    install.packages("qtlcharts")

Alternatively, install it from its
[GitHub repository](https://github.com/kbroman/qtlcharts). You first need to
install the [R/qtl](https://rqtl.org),
[htmlwidgets](http://www.htmlwidgets.org/),
and [devtools](https://github.com/hadley/devtools) packages.

    install.packages(c("qtl", "htmlwidgets", "devtools"))

Then install R/qtlcharts using the `install_github` function in the
[devtools](https://github.com/hadley/devtools) package.

    library(devtools)
    install_github("kbroman/qtlcharts")
