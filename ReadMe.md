### R/qtlcharts: Interactive graphics for QTL experiments

[![Build Status](https://travis-ci.org/kbroman/qtlcharts.svg?branch=master)](https://travis-ci.org/kbroman/qtlcharts)

[Karl W Broman](http://kbroman.org)

[R/qtlcharts](http://kbroman.org/qtlcharts) is an [R](http://www.r-project.org) package to create
interactive charts for QTL data, for use
with [R/qtl](http://www.rqtl.org). \[[website](http://kbroman.org/qtlcharts)\]

It is built with [D3](http://d3js.org), using a set of reusable
panels (also available separately, as [d3panels](http://kbroman.org/d3panels)).

For example charts, see the [R/qtlcharts website](http://kbroman.org/qtlcharts).

#### Installation

Install R/qtlcharts from its
[GitHub repository](https://github.com/kbroman/qtlcharts). You first need to
install the [R/qtl](http://www.rqtl.org),
[htmlwidgets](http://htmlwidgets.org),
and [devtools](https://github.com/hadley/devtools) packages.

```r
install.packages(c("qtl", "htmlwidgets", "devtools"))
```

Then install R/qtlcharts using the `install_github` function in the
[devtools](https://github.com/hadley/devtools) package.

```r
library(devtools)
install_github("kbroman/qtlcharts")
```

#### Example use

Try the following example, which creates an interactive chart with LOD
curves linked to estimated QTL effects.

```r
library(qtl)
library(qtlcharts)
data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)
iplotScanone(out, hyper)
```

Also try `iplotCorr`, an image of a correlation matrix (for the
gene expression of a set of 100 genes) linked to the underlying
scatterplots, with the points in the scatterplot colored by their
genotype at a QTL:

```r
library(qtlcharts)
data(geneExpr)
iplotCorr(geneExpr$expr, geneExpr$genotype)
```

Finally, try `iboxplot`, a plot of the quantiles of many
distributions, linked to the underlying histograms.

```r
library(qtlcharts)
# simulate some data
n.ind <- 500
n.gene <- 10000
expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
dimnames(expr) <- list(paste0("ind", 1:n.ind),
                       paste0("gene", 1:n.gene))
# generate the plot
iboxplot(expr)
```

#### Licenses

Licensed under the [MIT license](LICENSE). ([More information here](http://en.wikipedia.org/wiki/MIT_License).)

R/qtlcharts incorporates
- [D3.js](http://d3js.org) \[[license](inst/htmlwidgets/lib/d3/LICENSE)\]
- [d3.tip](https://github.com/Caged/d3-tip) \[[license](inst/htmlwidgets/lib/d3-tip/LICENSE)\]
- [ColorBrewer](http://colorbrewer2.org) \[[license](inst/htmlwidgets/lib/colorbrewer/LICENSE)\]
- [jQuery](http://jquery.com) \[[license](inst/htmlwidgets/lib/jquery/MIT-LICENSE.txt)\]
- [jQuery UI](http://jqueryui.com/) \[[license](inst/htmlwidgets/lib/jquery-ui/LICENSE.txt)\]
- [d3panels](https://github.com/kbroman/d3panels) \[[license](inst/htmlwidgets/lib/d3panels/License.md)\]
