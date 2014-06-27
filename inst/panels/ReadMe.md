## Reuseable D3-based panels

[Karl W Broman](http://www.biostat.wisc.edu/~kbroman)

This directory contains a set of reusable panels for
[D3](http://d3js.org)-based interactive charts for QTL data.

- [lodchart](inst/panels/lodchart): LOD curve panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/lodchart/test)\]
- [scatterplot](inst/panels/scatterplot): scatter plot panel
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/scatterplot/test)\]
- [dotchart](inst/panels/dotchart): dot plot panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/dotchart/test)\]
- [cichart](inst/panels/cichart): confidence interval plot panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/cichart/test)\]
- [curvechart](inst/panels/curvechart): panel for multiple curves
  (uses [d3.tip](http://github.com/Caged/d3-tip)
  and [ColorBrewer](http://colorbrewer2.org))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/curvechart/test)\]
- [mapchart](inst/panels/mapchart): genetic marker map panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/mapchart/test)\]
- [heatmap](inst/panels/heatmap): heat map panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/heatmap/test)\]
- [lodheatmap](inst/panels/lodheatmap): panel for heat map of LOD curves
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  \[[Example](http://kbroman.github.io/qtlcharts/assets/panels/lodheatmap/test)\]

Further utility functions are in [panelutil.coffee](panelutil.coffee).

#### Licenses

Licensed under the [MIT license](LICENSE). ([More information](http://en.wikipedia.org/wiki/MIT_License).)

R/qtlcharts incorporates [D3.js](http://d3js.org)
([see its license](../d3/LICENSE)),
[d3.tip](http://github.com/Caged/d3-tip)
([see its license](../d3-tip/LICENSE)), and
[ColorBrewer](http://colorbrewer2.org) ([see its license](../colorbrewer/LICENSE)).

