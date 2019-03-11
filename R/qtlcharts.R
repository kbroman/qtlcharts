#' R/qtlcharts: Interactive charts for QTL data
#'
#' A QTL is a *quantitative trait locus*: a genetic locus that
#' contributes to variation in a quantitative trait. The goal of
#' [R/qtlcharts](https://kbroman.org/qtlcharts) is to provide
#' interactive data visualizations for QTL analyses, and to make these
#' visualizations available from R. It is a companion to the
#' [R/qtl](http://rqtl.org) package.
#'
#' Vignettes online at the [R/qtlcharts website](https://kbroman.org/qtlcharts):
#'
#' - [User guide](https://kbroman.org/qtlcharts/assets/vignettes/userGuide.html)
#' - [Developer guide](https://kbroman.org/qtlcharts/assets/vignettes/develGuide.html)
#' - [Use with R Markdown](https://kbroman.org/qtlcharts/assets/vignettes/Rmarkdown.html)
#'   \[[Rmd source](https://github.com/kbroman/qtlcharts/blob/gh-pages/assets/vignettes/Rmarkdown.Rmd)\]
#' - [List of chart customization options](https://kbroman.org/qtlcharts/assets/vignettes/chartOpts.html)
#'
#' @name qtlcharts-package
#' @aliases qtlcharts
#' @docType package
NULL


#' Shiny bindings for R/qtlcharts widgets
#'
#' Output and render functions for using R/qtlcharts widgets within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like `"100\%"`,
#'   `"400px"`, `"auto"`) or a number, which will be coerced to a
#'   string and have `"px"` appended.
#' @param expr An expression that generates a networkD3 graph
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Is `expr` a quoted expression (with `quote()`)? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name qtlcharts-shiny
NULL
