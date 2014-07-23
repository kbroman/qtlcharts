### R/qtlcharts: Interactive graphics for QTL experiments

[Karl W Broman](http://kbroman.org)

[R/qtlcharts](http://kbroman.org/qtlcharts) is an [R](http://www.r-project.org) package to create
interactive charts for QTL data, for use
with [R/qtl](http://www.rqtl.org). \[[website](http://kbroman.org/qtlcharts)\]

It is built with [D3](http://d3js.org), using the following reusable components:
- [lodchart](inst/panels/lodchart): LOD curve panel
- [scatterplot](inst/panels/scatterplot): scatter plot panel
- [dotchart](inst/panels/dotchart): dot plot panel
- [cichart](inst/panels/cichart): confidence interval plot panel
- [curvechart](inst/panels/curvechart): panel for multiple curves
- [mapchart](inst/panels/mapchart): genetic marker map panel
- [heatmap](inst/panels/heatmap): heat map panel
- [lodheatmap](inst/panels/lodheatmap): panel for heat map of LOD curves
- [chrheatmap](inst/panels/chrheatmap): heat map panel broken into chromosomes
- [crosstab](inst/panels/crosstab): crosstab panel to display a cross-tabulation

For example charts, see the [R/qtlcharts website](http://kbroman.org/qtlcharts).

#### Installation

R/qtlcharts is early in development and so is not yet available on
[CRAN](http://cran.r-project.org).

You can install R/qtlcharts from its
[GitHub repository](http://github.com/kbroman/qtlcharts). You first need to
install the [R/qtl](http://www.rqtl.org),
[jsonlite](http://cran.r-project.org/web/packages/jsonlite),
and [devtools](https://github.com/hadley/devtools) packages.

```S
install.packages(c("qtl", "jsonlite", "devtools"))
```

Then install R/qtlcharts using the `install_github` function in the
[devtools](http://github.com/hadley/devtools) package.

```S
library(devtools)
install_github("kbroman/qtlcharts")
```

If that doesn't work, you might have an older version of devtools, so try:

```S
library(devtools)
install_github("qtlcharts", "kbroman")
```

#### Example use

Try the following example, which creates an interactive chart with LOD
curves linked to estimated QTL effects.

```S
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

```S
library(qtlcharts)
data(geneExpr)
iplotCorr(geneExpr$expr, geneExpr$genotype)
```

Finally, try `iboxplot`, a plot of the quantiles of many
distributions, linked to the underlying histograms.

```S
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

R/qtlcharts incorporates [D3.js](http://d3js.org)
([see its license](inst/d3/LICENSE)),
[d3.tip](http://github.com/Caged/d3-tip)
([see its license](inst/d3-tip/LICENSE)), and
[ColorBrewer](http://colorbrewer2.org) ([see its license](inst/colorbrewer/LICENSE)).
