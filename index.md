---
layout: page
title: R/qtlcharts
tagline: Interactive charts for QTL data
description: R/qtlcharts is an R package to create interactive charts for quantitative trait locus (QTL) mapping data, for use with R/qtl.
---

<a href="https://github.com/kbroman/qtlcharts"><img src="assets/pics/qtlcharts_logo.png" align="right" width="138" alt="qtlcharts logo"/></a>

[![R-CMD-check](https://github.com/kbroman/qtlcharts/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kbroman/qtlcharts/actions/workflows/R-CMD-check.yaml)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/qtlcharts)](https://cran.r-project.org/package=qtlcharts)
[![r-universe badge](https://kbroman.r-universe.dev/qtlcharts/badges/version)](https://kbroman.r-universe.dev/qtlcharts)
[![zenodo DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4049918.svg)](https://doi.org/10.5281/zenodo.4049918)

R/qtlcharts is an [R](https://www.r-project.org) package to create
interactive charts for QTL data, for use
with [R/qtl](https://rqtl.org).

A QTL is a _quantitative trait locus_: a genetic locus that
contributes to variation in a quantitative trait. The
goal of R/qtlcharts is to provide interactive data visualizations for QTL
analyses, and to make these visualizations available from [R](https://www.r-project.org).

The interactive visualizations are built with the JavaScript library
[D3](https://d3js.org) (version 7) and are viewed in a web
browser or with [RStudio](https://rstudio.com/).

A set of [reusable graphics panels](https://kbroman.org/d3panels/) form the basis
for the larger visualizations.

To cite R/qtlcharts in publications, please use

> Broman KW (2015) R/qtlcharts: interactive graphics for quantitative
> trait locus mapping. Genetics 199:359-361.
> [`doi:10.1534/genetics/114.172742`](https://doi.org/10.1534/genetics.114.172742)

---

- [Installation](pages/installation.html)
- [User guide](assets/vignettes/userGuide.html)
- [Developer guide](assets/vignettes/develGuide.html)
- [d3panels](https://kbroman.org/d3panels/): reusable graphic panels
- [Use with R Markdown](assets/vignettes/Rmarkdown.html) [[Rmd source](https://github.com/kbroman/qtlcharts/blob/main/vignettes/Rmarkdown.Rmd)]
- [List of chart customization options](assets/vignettes/chartOpts.html)
- [Examples of use with Shiny](https://github.com/kbroman/shiny_qtlcharts)
- [Examples of use with Jupyter notebooks](https://github.com/kbroman/jupyter_qtlcharts)


---

### Example charts

Click on a chart for the corresponding interactive version.

<table class="wide">
<tr>
  <td class="left">
    <a href="example/iplotScanone.html">
        <img src="assets/pics/iplotScanone.png" alt="iplotScanone example" title="iplotScanone example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotCorr.html">
        <img src="assets/pics/iplotCorr.png" alt="iplotCorr example" title="iplotCorr example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotMScanone.html">
        <img src="assets/pics/iplotMScanone.png" alt="iplotMScanone example" title="iplotMScanone example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotMap.html">
        <img src="assets/pics/iplotMap.png" alt="iplotMap example" title="iplotMap example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotCurves.html">
        <img src="assets/pics/iplotCurves.png" alt="iplotCurves example" title="iplotCurves example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iheatmap.html">
        <img src="assets/pics/iheatmap.png" alt="iheatmap example" title="iheatmap example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iboxplot.html">
        <img src="assets/pics/iboxplot.png" alt="iboxplot example" title="iboxplot example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotRF.html">
        <img src="assets/pics/iplotRF.png" alt="iplotRF example" title="iplotRF example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/ipleiotropy.html">
        <img src="assets/pics/ipleiotropy.png" alt="ipleiotropy example" title="ipleiotropy example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/scat2scat.html">
        <img src="assets/pics/scat2scat.png" alt="scat2scat example" title="scat2scat example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/itimeplot.html">
        <img src="assets/pics/itimeplot.png" alt="itimeplot example" title="itimeplot example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplot.html">
        <img src="assets/pics/iplot.png" alt="iplot example" title="iplot example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/itriplot.html">
        <img src="assets/pics/itriplot.png" alt="itriplot example" title="itriplot example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/idotplot.html">
        <img src="assets/pics/idotplot.png" alt="idotplot example" title="idotplot example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotScantwo.html">
        <img src="assets/pics/iplotScantwo.png" alt="iplotScantwo example" title="iplotScantwo example"/>
    </a>
  </td>
  <td class="right">
  </td>
</tr>
</table>

---

Sources on [github](https://github.com):

- The [source for the package](https://github.com/kbroman/qtlcharts/tree/main)
- The [source for the website](https://github.com/kbroman/qtlcharts/tree/gh-pages)
