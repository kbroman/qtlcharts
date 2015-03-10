---
layout: page
title: Installing R/qtlcharts
description: Instructions on how to install the R/qtlcharts package.
---

R/qtlcharts is a package for [R](http://www.r-project.org). To use it,
you first need to [download](http://cran.r-project.org/) and install
R. We also recommend the use of [RStudio](http://www.rstudio.com/),
which provides a very nice
[user interface for R](http://www.rstudio.com/products/rstudio/download/).

Install R/qtlcharts from its
[GitHub repository](https://github.com/kbroman/qtlcharts). You first need to
install the [R/qtl](http://www.rqtl.org),
[htmlwidgets](http://www.htmlwidgets.org/)
and [devtools](https://github.com/hadley/devtools) packages.

    install.packages(c("qtl", "htmlwidgets", "devtools"))

Then install R/qtlcharts using the `install_github` function in the
[devtools](https://github.com/hadley/devtools) package.

    library(devtools)
    install_github("kbroman/qtlcharts")
