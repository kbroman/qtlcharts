# qtlcharts 0.5-3

- Added `idotplot` function for plotting a quantitative variable in
  different categories.  (It's just like `iplotPXG`, but with data
  values not connected to a cross object.)

- Reorganized the [d3panels](http://kbroman.org/d3panels) code: just
  using `d3panels.min.js` and `d3panels.min.css` rather than linking
  to js code for individual panels.


# qtlcharts 0.5-1

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
