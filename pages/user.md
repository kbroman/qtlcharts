---
layout: page
title: User guide
---

A more comprehensive User Guide for R/qtlcharts is planned. For now,
here are some examples of the use of each of the charts.

To use R/qtlcharts, you'll first need to
[install the package](installation.html), and load it with
`library(qtlcharts)`. The [R/qtl](http://www.rqtl.org) and
[RJSONIO](http://cran.r-project.org/web/packages/RJSONIO) will also be
loaded.

### iplotMap

iplotMap creates a (slightly) interactive genetic map. Hover over a
marker position to view the marker name.

    data(hyper)
    map <- pull.map(hyper)

    iplotMap(map, title="iplotMap example")


### iplotScanone

iplotScanone creates an interactive chart with LOD
curves linked to estimated QTL effects.


    data(hyper)
    hyper <- calc.genoprob(hyper, step=1)
    out <- scanone(hyper)

    iplotScanone(out, hyper, title="iplotScanone example")


### iplotMScanone

iplotMScanone creates a heatmap of LOD curves for a set of genome
scans (for each, for each of a time course of phenotypes), linked to a
plot of the individual genome scans, and also to the QTL effects.

    data(grav)
    grav <- calc.genoprob(grav, step=1)
    grav <- reduce2grid(grav)
    phecol <- seq(1, nphe(grav), by=5)
    out <- scanone(grav, phe=phecol)
    eff <- estQTLeffects(grav, phe=phecol, what="effects")

    iplotMScanone(out, effects=eff,
                  title="iplotMScanone example",
                  chartOpts=list(eff_ylab="QTL effect"))


### iplotCorr

iplotCorr creates an heat map of a correlation matrix, linked to the
underlying scatterplots.

    data(geneExpr)

    iplotCorr(geneExpr$expr, geneExpr$genotype,
              title = "iplotCorr example",
              chartOpts=list(cortitle="Correlation matrix",
                             scattitle="Scatterplot"))


### iplotCurves

iplotCurves creates a plot of a set of curves linked to one or two
scatterplots.

    data(grav)
    times <- attr(grav, "time")
    phe <- grav$pheno

    iplotCurves(phe, times, phe[,times==2 | times==4], phe[,times==4 | times==6],
                title="iplotCurves example",
                chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Root tip angle (degrees)",
                               scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
                               scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"))


### iboxplot

iboxplot creates an interactive graph for a large set of box plots
(rendered as lines connecting the quantiles), linked to underlying
histograms.

    # simulated data
    n.ind <- 500
    n.gene <- 10000
    expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
    dimnames(expr) <- list(paste0("ind", 1:n.ind),
                           paste0("gene", 1:n.gene))

    iboxplot(expr, title="iboxplot example",
             chartOpts=list(xlab="Mice", ylab="Gene expression"))
