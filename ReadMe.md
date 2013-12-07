### qtlcharts: Interactive graphics for QTL experiments

Karl W Broman,
[http://www.biostat.wisc.edu/~kbroman](http://www.biostat.wisc.edu/~kbroman)

I'm in the process of turning this code into an R package. (I should
have made a branch!)

This is an [R](http://www.r-project.org) package to create
[D3](http://d3js.org)-based interactive charts for xQTL data, for use
with the [R/qtl](http://www.rqtl.org) package.

It is built on the following reuseable components:
- [lodchart](inst/panels/lodchart): LOD curve panel
- [scatterplot](inst/panels/scatterplot): scatter plot panel

It makes use of the [D3](http://d3js.org) library;
[see the license for D3](inst/d3/LICENSE).

<hr/>
Licensed under the [MIT license](LICENSE). ([More information](http://en.wikipedia.org/wiki/MIT_License))
