---
layout: page
title: R/qtlcharts
tagline: Interactive charts for QTL data
description: R/qtlcharts is an R package to create interactive charts for quantitative trait locus (QTL) mapping data, for use with R/qtl.
---

[![R-CMD-check](https://github.com/kbroman/qtlcharts/workflows/R-CMD-check/badge.svg)](https://github.com/kbroman/qtlcharts/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/qtlcharts)](https://cran.r-project.org/package=qtlcharts)

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
[Broman KW (2015) R/qtlcharts: interactive graphics for quantitative trait locus mapping. Genetics 199:359-361](https://pubmed.ncbi.nlm.nih.gov/25527287/).

---

- [Installation](pages/installation.html)
- [User guide](assets/vignettes/userGuide.html)
- [Developer guide](assets/vignettes/develGuide.html)
- [d3panels](https://kbroman.org/d3panels/): reusable graphic panels
- [Use with R Markdown](assets/vignettes/Rmarkdown.html) [[Rmd source](https://github.com/kbroman/qtlcharts/blob/master/vignettes/Rmarkdown.Rmd)]
- [List of chart customization options](assets/vignettes/chartOpts.html)

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

- The [source for the package](https://github.com/kbroman/qtlcharts/tree/master)
- The [source for the website](https://github.com/kbroman/qtlcharts/tree/gh-pages)
