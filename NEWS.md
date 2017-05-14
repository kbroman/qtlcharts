## qtlcharts 0.9-1 (2017-05-14)

- Added new tool for exploring pleiotropy between two traits,
  `ipleiotropy()`.


## qtlcharts 0.8-2 (2017-05-11)

- Updated to use [D3](https://d3js.org)
  [version 4](https://github.com/d3/d3/blob/master/API.md).

- Also updated d3panels, d3-tip, jquery, and jquery-ui.


## qtlcharts 0.7-8 (2016-06-28)

- Rewrite underlying javascript to use new version of
  [d3panels](http://kbroman.org/d3panels).

- Add a new chart, `scat2scat`. The idea is to summarize each of a
  long series of scatterplots with a pair of numbers. Then a
  scatterplot of those summary statistics is linked to the underlying
  details: click on a point in the main scatterplot and have the
  underlying scatterplot be shown.

- Add a new chart, `itriplot`, for plotting trinomial probabilities,
  represented as points in an equilateral triangle.

- Refactor `iplotPXG` and `idotplot` so that `idotplot` is the main
  function, and `iplotPXG` calls it.

- Add some additional options, such as `horizontal` for `iplotMap`
  and `iplotPXG`.

- Change the name of some options, such as `linecolor` and `linewidth`
  in `iplotCurves` (in place of `strokecolor` and `strokewidth`).

- Add a `digits` argument for all plot functions, with the aim to
  reduce the size of the datasets included in the resulting charts.

- Removed the vignettes from the package (for complicated reasons);
  they're available at the
  [R/qtlcharts website](http://kbroman.org/qtlcharts).


## qtlcharts 0.6-6 (2016-04-21)

- Fix proliferation of tool tips

- For use with Shiny, clear SVG before drawing


## qtlcharts 0.5-25 (2015-11-09)

- Skip Rmd and html tests run on CRAN (so faster, and because the Rmd
  tests won't work on Solaris as they need pandoc).


## qtlcharts 0.5-23 (2015-11-07)

- Changed license and author list in order to post the package on
  CRAN, http://cran.r-project.org

- `idotplot` and `iplot` now use the names of the input data as
  individual IDs if `indID` is missing or `NULL`.


## qtlcharts 0.5-18 (2015-09-02)

- Fixed a bug in `iplotScanone` with `pxgtype="ci"`. In the case of
  phenotypes with missing values, the confidence intervals were
  incorrect.


## qtlcharts 0.5-15 (2015-06-24)

- `iplotCorr` has argument `scatterplots` that controls whether
  scatterplots will be shown when clicking on pixels in the heatmap.
  (If `scatterplots=FALSE`, we skip the scatterplots.)


## qtlcharts 0.5-13 (2015-06-08)

- `iplotMScanone` can plot just points (rather than curves) for the
  LOD scores and QTL effects in the lower and right-hand panels.

- Fix a bug in `iplotMScanone` (x-axis labels in right-hand plot
  weren't being shown)


## qtlcharts 0.5-10 (2015-05-28)

- Included [bower](http://bower.io) information, about the javascript
  libraries, within the source package.


## qtlcharts 0.5-8 (2015-05-13)

- Got the package working with
  [jsonlite](https://github.com/jeroenooms/jsonlite), as
  [htmlwidgets](http://www.htmlwidgets.org) has now switched from
  [RJSONIO](http://www.omegahat.net/RJSONIO/) to jsonlite, for
  converting R objects to [JSON](http://www.json.org/).


## qtlcharts 0.5-4 (2015-03-10)

- Added `setScreenSize` function for controlling the default sizes of
  charts.


## qtlcharts 0.5-3 (2015-03-05)

- Added `idotplot` function for plotting a quantitative variable in
  different categories.  (It's just like `iplotPXG`, but with data
  values not connected to a cross object.)

- Reorganized the [d3panels](http://kbroman.org/d3panels) code: just
  using `d3panels.min.js` and `d3panels.min.css` rather than linking
  to js code for individual panels.


## qtlcharts 0.5-1 (2015-03-05)

- Refactored the entire package to use
  [htmlwidgets](http://www.htmlwidgets.org).
  A big advantage is that the charts now work nicely within
  [RStudio](http://www.rstudio.com/products/RStudio/).

- To save a plot to a file, you now need to assign the result of a plot
  function to an object and then use the
  [htmlwidgets](http://www.htmlwidgets.org) function `saveWidget`.

  ```r
  library(qtlcharts)
  library(qtl)
  data(hyper)
  hyper <- calc.genoprob(hyper, step=1)
  out <- scanone(hyper)
  chart <- iplotScanone(out, hyper)
  htmlwidgets::saveWidget(chart, file="hyper_scanone.html")
  ```

- It's now simpler to include interactive charts within an R Markdown
  document. You simply make the plots in a code chunk in the way that
  you would at the R prompt. There's no longer a need to worry about
  `print_qtlcharts_resources()` or `results="asis"`.

- Separated out the basic panel functions as a separate repository,
  [d3panels](http://kbroman.org/d3panels), to make it easier for them
  to be used separately from
  [R/qtlcharts](http://kbroman.org/qtlcharts).
