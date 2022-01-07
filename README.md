### R/qtlcharts: Interactive graphics for QTL experiments

[![R-CMD-check](https://github.com/kbroman/qtlcharts/workflows/R-CMD-check/badge.svg)](https://github.com/kbroman/qtlcharts/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/qtlcharts)](https://cran.r-project.org/package=qtlcharts)

[Karl W Broman](https://kbroman.org)

[R/qtlcharts](https://kbroman.org/qtlcharts/) is an [R](https://www.r-project.org) package to create
interactive charts for QTL data, for use
with [R/qtl](https://rqtl.org).

It is built with [D3](https://d3js.org), using a set of reusable
panels (also available separately, as [d3panels](https://kbroman.org/d3panels/)).

For example charts, see the [R/qtlcharts website](https://kbroman.org/qtlcharts/).

#### Installation

Install R/qtlcharts from CRAN using

```r
install.packages("qtlcharts")
```

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

The R/qtlcharts package as a whole is distributed under
[GPL-3 (GNU General Public License version 3)](https://www.gnu.org/licenses/gpl-3.0.en.html).

R/qtlcharts incorporates the following other open source software
components, which have their own license agreements.

- [D3.js](https://d3js.org) ([license](https://github.com/kbroman/qtlcharts/blob/main/inst/htmlwidgets/lib/d3/LICENSE))
- [jQuery](https://jquery.com) ([license](https://github.com/kbroman/qtlcharts/blob/main/inst/htmlwidgets/lib/jquery/LICENSE.txt))
- [jQuery UI](https://jqueryui.com/) ([license](https://github.com/kbroman/qtlcharts/blob/main/inst/htmlwidgets/lib/jquery-ui/LICENSE.txt))
- [d3panels](https://kbroman.org/d3panels/) ([license](https://github.com/kbroman/qtlcharts/blob/main/inst/htmlwidgets/lib/d3panels/LICENSE.md))
