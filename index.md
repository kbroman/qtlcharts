---
layout: page
title: R/qtlcharts
tagline: Interactive charts for QTL data
description: R/qtlcharts is an R package to create interactive charts for quantitative trait locus (QTL) mapping data, for use with R/qtl.
---

R/qtlcharts is an [R](http://www.r-project.org) package to create
interactive charts for QTL data, for use
with [R/qtl](http://www.rqtl.org).

A QTL is a _quantitative trait locus_: a genetic locus that
contributes to variation in a quantitative trait. The
goal of R/qtlcharts is to provide interactive data visualizations for QTL
analyses, and to make these visualizations available from [R](http://www.r-project.org).

The interactive visualizations are built with the JavaScript library
[D3](http://d3js.org), and are viewed in a web browser. We are
targeting Chrome and Safari and, as much as possible, Firefox.

A set of [reusable graphics panels](pages/panels.html) form the basis
for the larger visualizations.

---

- [Installation](pages/installation.html)
- [User guide](assets/vignettes/userGuide.html)
- [Developer guide](assets/vignettes/develGuide.html)
- [Reusable graphic panels](pages/panels.html)
- [Use with R Markdown](assets/vignettes/Rmarkdown.html)
- [List of chart customization options](assets/vignettes/chartOpts.html)

---

### Example charts

Click on a chart for the corresponding interactive version.

<table class="wide">
<tr>
  <td class="left">
    <a href="example/iplotScanone.html">
        <img src="assets/pics/charts/iplotScanone.png" alt="iplotScanone example" title="iplotScanone example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotCorr.html">
        <img src="assets/pics/charts/iplotCorr.png" alt="iplotCorr example" title="iplotCorr example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotMScanone.html">
        <img src="assets/pics/charts/iplotMScanone.png" alt="iplotMScanone example" title="iplotMScanone example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotMap.html">
        <img src="assets/pics/charts/iplotMap.png" alt="iplotMap example" title="iplotMap example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotCurves.html">
        <img src="assets/pics/charts/iplotCurves.png" alt="iplotCurves example" title="iplotCurves example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iheatmap.html">
        <img src="assets/pics/charts/iheatmap.png" alt="iheatmap example" title="iheatmap example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iboxplot.html">
        <img src="assets/pics/charts/iboxplot.png" alt="iboxplot example" title="iboxplot example"/>
    </a>
  </td>
  <td class="right">
    <a href="example/iplotRF.html">
        <img src="assets/pics/charts/iplotRF.png" alt="iplotRF example" title="iplotRF example"/>
    </a>
  </td>
</tr>
<tr>
  <td class="left">
    <a href="example/iplotScantwo.html">
        <img src="assets/pics/charts/iplotScantwo.png" alt="iplotScantwo example" title="iplotScantwo example"/>
    </a>
  </td>
  <td class="right">
  </td>
</tr>
</table>

---

Sources on [github](http://github.com):

- The [source for the package](https://github.com/kbroman/qtlcharts/tree/master)
- The [source for the website](https://github.com/kbroman/qtlcharts/tree/gh-pages)
