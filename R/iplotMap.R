## iplotMap
## Karl W Broman

#' Interactive genetic map plot
#'
#' Creates an interactive graph of a genetic marker map.
#'
#' @param map Object of class \code{"map"}, a list with each component
#'   being a vector of marker positions. You can also provide an object of
#'   class \code{"cross"}, in which case the map is extracted with
#'   \code{\link[qtl]{pull.map}}.
#' @param chr (Optional) Vector indicating the chromosomes to plot.
#' @param shift If TRUE, shift each chromsome so that the initial marker
#'   is at position 0.
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotPXG}}
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' map <- pull.map(hyper)
#' \donttest{
#' iplotMap(map, shift=TRUE)}
#'
#' @export
iplotMap <-
function(map, chr, shift=FALSE, chartOpts=NULL)
{
    if("cross" %in% class(map)) map <- qtl::pull.map(map)

    if(!missing(chr) && !is.null(chr)) {
        map <- map[chr]
        if(length(map) == 0)
            stop("No chromosomes selected")
    }

    map_list <- convert_map(map)
    chartOpts <- add2chartOpts(chartOpts, shiftStart=shift)
    x <- list(data=map_list, chartOpts=chartOpts)

    defaultAspect <- 1.5 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("iplotMap", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize$width,
                                  browser.defaultHeight=browsersize$height,
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=1000/defaultAspect
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotMap_output <- function(outputId, width="100%", height="680") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotMap", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotMap_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotMap_output, env, quoted=TRUE)
}
