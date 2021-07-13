## iplotMap
## Karl W Broman

#' Interactive genetic map plot
#'
#' Creates an interactive graph of a genetic marker map.
#'
#' @param map Object of class `"map"`, a list with each component
#'   being a vector of marker positions. You can also provide an object of
#'   class `"cross"`, in which case the map is extracted with
#'   [qtl::pull.map()].
#' @param chr (Optional) Vector indicating the chromosomes to plot.
#' @param shift If TRUE, shift each chromsome so that the initial marker
#'   is at position 0.
#' @param horizontal If TRUE, have chromosomes arranged horizontally
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso [iplotScanone()], [iplotPXG()]
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
function(map, chr=NULL, shift=FALSE, horizontal=FALSE, chartOpts=NULL, digits=5)
{
    if(inherits(map, "cross")) map <- qtl::pull.map(map)

    if(!is.null(chr)) {
        map <- map[chr]
        if(length(map) == 0)
            stop("No chromosomes selected")
    }

    map_list <- convert_map(map)
    chartOpts <- add2chartOpts(chartOpts, shiftStart=shift, horizontal=horizontal)
    x <- list(data=map_list, chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

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
