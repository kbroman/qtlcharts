#' R/qtlcharts: Interactive charts for QTL data
#'
#' A QTL is a \emph{quantitative trait locus}: a genetic locus that
#' contributes to variation in a quantitative trait. The goal of
#' \href{http://kbroman.org/qtlcharts}{R/qtlcharts} is to provide
#' interactive data visualizations for QTL analyses, and to make these
#' visualizations available from R. It is a companion to the
#' \href{http://www.rqtl.org}{R/qtl} package.
#'
#' Vignettes online at the \href{http://kbroman.org/qtlcharts}{R/qtlcharts website}:
#'
#' \itemize{
#' \item \href{http://kbroman.org/qtlcharts/assets/vignettes/userGuide.html}{User guide}
#' \item \href{http://kbroman.org/qtlcharts/assets/vignettes/develGuide.html}{Developer guide}
#' \item \href{http://kbroman.org/qtlcharts/assets/vignettes/Rmarkdown.html}{Use with R Markdown}
#'   [\href{https://github.com/kbroman/qtlcharts/blob/gh-pages/assets/vignettes/Rmarkdown.Rmd}{Rmd source}]
#' \item \href{http://kbroman.org/qtlcharts/assets/vignettes/chartOpts.html}{List of chart customization options}
#' }
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
#' @param width,height Must be a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended.
#' @param expr An expression that generates a networkD3 graph
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name qtlcharts-shiny
NULL
