### R/qtlcharts: Interactive graphics for QTL experiments

Karl W Broman,
[http://www.biostat.wisc.edu/~kbroman](http://www.biostat.wisc.edu/~kbroman)

This is an [R](http://www.r-project.org) package to create
[D3](http://d3js.org)-based interactive charts for xQTL data, for use
with the [R/qtl](http://www.rqtl.org) package.

It is built on the following reuseable components:
- [lodchart](inst/panels/lodchart): LOD curve panel
- [scatterplot](inst/panels/scatterplot): scatter plot panel
- [dotchart](inst/panels/dotchart): dot plot panel
- [cichart](inst/panels/cichart): confidence interval plot panel
- [curvechart](inst/panels/curvechart): panel for multiple curves


#### Installation

You first need to install [R/qtl](http://www.rqtl.org) and the
[RJSONIO](http://cran.r-project.org/web/packages/RJSONIO/index.html)
package:

    if(!require(qtl)) install.packages("qtl")
    if(!require(RJSONIO)) install.packages("RJSONIO")

You also need the `install_github` function in
[Hadley Wickham](http://had.co.nz/)'s [devtools](http://github.com/hadley/devtools) package. So install
and load devtools:

    if(!require(devtools)) install.packages("devtools")
    library(devtools)

Finally, use `install_github` function to install R/qtlcharts:

    install_github("kbroman/qtlcharts")

If that doesn't work, you might have an older version of devtools, so try:

    install_github("qtlcharts", "kbroman")


#### Example use

Try the following example, which creates an interactive chart with LOD
curves linked to estimated QTL effects.

    library(qtlcharts)
    data(hyper)
    hyper <- calc.genoprob(hyper, step=1)
    out <- scanone(hyper)
    iplotScanone(out, hyper)

Also try `corr_w_scatter`, an image of a correlation matrix (for the
gene expression of a set of 100 genes) linked to the underlying
scatterplots, with the points in the scatterplot colored by their
genotype at a QTL:

    library(qtlcharts)
    data(geneExpr)
    corr_w_scatter(geneExpr$expr, geneExpr$genotype)

Finally, try `manyboxplots`, a plot of the quantiles of many
distributions, linked to the underlying histograms.

    library(qtlcharts)
    # simulate some data
    n.ind <- 500
    n.gene <- 10000
    expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
    dimnames(expr) <- list(paste0("ind", 1:n.ind),
                           paste0("gene", 1:n.gene))
    # generate the plot
    manyboxplots(expr)

#### Licenses

Licensed under the [MIT license](LICENSE). ([More information](http://en.wikipedia.org/wiki/MIT_License).)

R/qtlcharts incorporates [D3.js](http://d3js.org)
([see its license](inst/d3/LICENSE)),
[d3.tip](http://github.com/Caged/d3-tip)
([see its license](inst/d3-tip/LICENSE)), and
[ColorBrewer](http://colorbrewer2.org) ([see its license](inst/colorbrewer/LICENSE)).

