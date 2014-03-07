## Reuseable D3-based panels

Karl W Broman,
[http://www.biostat.wisc.edu/~kbroman](http://www.biostat.wisc.edu/~kbroman)

This directory contains a set of reusable panels for
[D3](http://d3js.org)-based interactive charts for xQTL data.

- [lodchart](inst/panels/lodchart): LOD curve panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))
  
- [scatterplot](inst/panels/scatterplot): scatter plot panel

- [dotchart](inst/panels/dotchart): dot plot panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))

- [cichart](inst/panels/cichart): confidence interval plot panel
  (uses [d3.tip](http://github.com/Caged/d3-tip))

- [curvechart](inst/panels/curvechart): panel for multiple curves
  (uses [ColorBrewer](http://colorbrewer2.org))

Further utility functions are in [panelutil.coffee](panelutil.coffee).

#### Licenses

Licensed under the [MIT license](LICENSE). ([More information](http://en.wikipedia.org/wiki/MIT_License).)

R/qtlcharts incorporates [D3.js](http://d3js.org)
([see its license](../d3/LICENSE)),
[d3.tip](http://github.com/Caged/d3-tip)
([see its license](../d3-tip/LICENSE)), and
[ColorBrewer](http://colorbrewer2.org) ([see its license](../colorbrewer/LICENSE))

