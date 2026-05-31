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

```r
install.packages("qtlcharts")
```

Alternatively, install it from [R
universe](https://kbroman.r-universe.dev):

```r
install.packages("qtlcharts", repos=c("https://kbroman.r-universe.dev",
                                      "https://cloud.r-project.org"))
```

Or install it from its
[GitHub repository](https://github.com/kbroman/qtlcharts)
with the [remotes](https://github.com/r-lib/remotes) package:

```r
install.packages("remotes")
remotes::install_github("kbroman/qtlcharts")
```

The packages [R/qtl](https://rqtl.org) and
[htmlwidgets](https://www.htmlwidgets.org) will also be installed.
