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


#### Installation

You first need to install [R/qtl](http://www.rqtl.org) and the
[RJSONIO](http://cran.r-project.org/web/packages/RJSONIO/index.html)
package:

    install.packages("qtl")
    install.packages("RJSONIO")

You also need the `install_github` function in
[Hadley Wickham](http://had.co.nz/)'s [devtools]() package. So install
and load devtools:

    install.packages("devtools")
    library(devtools)

Finally, use `install_github` function to install R/qtlcharts:

    install_github("kbroman/qtlcharts")

If that doesn't work, you might have an older version of devtools, so try:

    install_github("qtlcharts", "kbroman")


#### Example use

There aren't many functions available yet, but you can try this:

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

#### Licenses

Licensed under the [MIT license](LICENSE). ([More information](http://en.wikipedia.org/wiki/MIT_License).)

R/qtlcharts incorporates [D3.js](http://d3js.org)
([see its license](inst/d3/LICENSE)) and
[d3.tip](http://github.com/Caged/d3-tip)
([see its license](inst/d3-tip/LICENSE)).

