## qtlcharts 0.17-3 (2025-05-09)

- In CITATION file, change `citEntry()` to `bibentry()`.

- Upgrade d3 to 7.8.2

- Upgrade jquery to 3.6.4


## qtlcharts 0.16 (2022-01-07)

- Update d3panels to 1.8.4, with improvement to `formatAxis()`.
  This should fix Issue #77.

- Fix `qtlchartsversion()` to handle case like "0.14"


## qtlcharts 0.14 (2021-08-05)

- Upgrade D3 to 7.0.0 (and d3panels to 1.8.0)

- Allow `iplot()` to not take `y` argument (in which case we move `x`
  to `y` and take `x` to be indices). (Issue #73)

- Add `horizontal` argument to `iplotMap()` to lay out the chromosomes
  horizontally. This was already available as a chartOpts option, but
  this makes it easier. (Issue #67)

- Fix error in `itriplot()` for case of a single point (Issue #76)


## qtlcharts 0.12-10 (2020-09-24)

- Replaced use of [d3-tip](https://github.com/Caged/d3-tip) with
  custom tool tips, and upgraded to [D3 version 5](https://d3js.org).

- `itriplot()` will now take labels from the column names of the
  probabilities, `p`. Also has an option for grid lines.

- Allowed `title` as chart option in `iplotMScanone()`,
  `iplotScanone()`, `iheatmap()`.

- Added `scat_title` chart option to `ipleiotropy()`, for a title on the
  scatterplot panel.

- Filled in some missing text in the help info for `iplotMScanone()`.

- Converted documentation to markdown.

- Fixed use of `class()`, replacing constructions like `"cross" %in% class(object)`
  with `inherits(object, "cross")`.


## qtlcharts 0.11-6 (2019-02-04)

- Fix bug in `idotplot()` so that it works with a single group.

- Fix bug in `iplotMap()` so that the drop-down menu works in Firefox.


## qtlcharts 0.11-4 (2018-03-08)

- Update to use CoffeeScript v 2.2.2. Using
  [babel](https://babeljs.io) to compile to ES5.

- Switch from [bower](https://bower.io) to
  [yarn](https://classic.yarnpkg.com/en/) for javascript dependency
  management.

- Revise `scat2scat()` so that the chart options `xlab2` and `ylab2`
  can be vectors of length of `scat2data`, so that each dataset can
  have different x- and y-axis labels. Default is to take them from
  the column names of the datasets in `scat2data`.


## qtlcharts 0.10-1 (2017-06-01)

- All charts can now take a `heading` and a `footer` within
  `chartOpts`. The former will make an `<h2>` heading above the
  figure; the latter will make a `<div>` at the bottom. These are
  intended for stand-alone html files.

- In the `caption` chart option, now using `.html()` rather than
  `.text()` so that you can insert a bit of html (such as `<b>` or
  `<code>`).


## qtlcharts 0.9-6 (2017-05-24)

- All charts now can take a `caption` within `chartOpts` which will
  show up as text below the figure. This is intended for stand-alone
  html files.


## qtlcharts 0.9-5 (2017-05-19)

- Added new tool for exploring pleiotropy between two traits,
  `ipleiotropy()`.

- Fixed X chromosome case in iplotScantwo, so that only relevant
  two-locus genotypes are shown.

- Added new chart option `pointsize` for `iplotCorr`.

- In the coffeescript functions, ensure that list arguments like
  `margin` have all of the necessary components. This avoid the
  problem of everything being messed up if for example `margin` is
  specified within defining `margin.inner`.

- `lodcharts` now includes a quantitative scale for position on the
  x-axis in the case of a single chromosome

- In `iplotScanone` and `iplotScantwo`, in phenotype x genotype plots
  when switching between markers on the same chromosome, animate the
  movement of the points rather than destroying and re-creating the
  panel.


## qtlcharts 0.8-2 (2017-05-11)

- Updated to use [D3](https://d3js.org)
  [version 4](https://github.com/d3/d3/blob/main/API.md).

- Also updated d3panels, d3-tip, jquery, and jquery-ui.


## qtlcharts 0.7-8 (2016-06-28)

- Rewrite underlying javascript to use new version of
  [d3panels](https://kbroman.org/d3panels/).

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
  [R/qtlcharts website](https://kbroman.org/qtlcharts/).


## qtlcharts 0.6-6 (2016-04-21)

- Fix proliferation of tool tips

- For use with Shiny, clear SVG before drawing


## qtlcharts 0.5-25 (2015-11-09)

- Skip Rmd and html tests run on CRAN (so faster, and because the Rmd
  tests won't work on Solaris as they need pandoc).


## qtlcharts 0.5-23 (2015-11-07)

- Changed license and author list in order to post the package on
  CRAN, <https://cran.r-project.org>

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

- Included [bower](https://bower.io) information, about the javascript
  libraries, within the source package.


## qtlcharts 0.5-8 (2015-05-13)

- Got the package working with
  [jsonlite](https://github.com/jeroen/jsonlite), as
  [htmlwidgets](https://www.htmlwidgets.org) has now switched from
  [RJSONIO](https://www.omegahat.net/RJSONIO/) to jsonlite, for
  converting R objects to [JSON](https://www.json.org/json-en.html).


## qtlcharts 0.5-4 (2015-03-10)

- Added `setScreenSize` function for controlling the default sizes of
  charts.


## qtlcharts 0.5-3 (2015-03-05)

- Added `idotplot` function for plotting a quantitative variable in
  different categories.  (It's just like `iplotPXG`, but with data
  values not connected to a cross object.)

- Reorganized the [d3panels](https://kbroman.org/d3panels/) code: just
  using `d3panels.min.js` and `d3panels.min.css` rather than linking
  to js code for individual panels.


## qtlcharts 0.5-1 (2015-03-05)

- Refactored the entire package to use
  [htmlwidgets](https://www.htmlwidgets.org).
  A big advantage is that the charts now work nicely within
  [RStudio](https://posit.co/products/open-source/rstudio/)

- To save a plot to a file, you now need to assign the result of a plot
  function to an object and then use the
  [htmlwidgets](https://www.htmlwidgets.org) function `saveWidget`.

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
  [d3panels](https://kbroman.org/d3panels/), to make it easier for them
  to be used separately from
  [R/qtlcharts](https://kbroman.org/qtlcharts/).
