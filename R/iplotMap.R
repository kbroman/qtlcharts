## iplotMap
## Karl W Broman

#' Interactive genetic map plot
#'
#' Creates an interactive graph of a genetic marker map.
#'
#' @param map Object of class \code{"map"}, a list with each component
#'   being a vector of marker positions.
#' @param shift If TRUE, shift each chromsome so that the initial marker
#'   is at position 0.
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#'
#' @return None.
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
function(map, shift=FALSE, chartOpts=NULL)
{
    if("cross" %in% class(map)) map <- qtl::pull.map(map)

    if(shift) map <- qtl::shiftmap(map)
    map_list <- convert_map(map)
    x <- list(data=map_list, chartOpts=chartOpts)

    htmlwidgets::createWidget("iplotMap", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

# convert map to special list
convert_map <-
function(map) {
    chrnames <- names(map)

    # remove the A/X classes
    map <- sapply(map, unclass)

    mnames <- unlist(lapply(map, names))
    names(mnames) <- NULL

    list(chr=chrnames, map=map, markernames=mnames)
}

#' @export
iplotMap_output <- function(outputId, width="100%", height="680") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotMap", width, height, package="qtlcharts")
}
#' @export
iplotMap_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotMap_output, env, quoted=TRUE)
}
