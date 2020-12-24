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
[GitHub repository](https://github.com/kbroman/qtlcharts). First
install the [remotes](https://github.com/r-lib/remotes) package.

```r
install.packages("remotes")
```

Then install R/qtlcharts using the `install_github` function in
[remotes](https://github.com/r-lib/remotes).

```r
library(remotes)
install_github("kbroman/qtlcharts")
```

The packages [R/qtl](https://rqtl.org) and
[htmlwidgets](https://www.htmlwidgets.org) will also be installed.
