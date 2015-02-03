## iheatmap
## Karl W Broman

#' Interactive heat map
#'
#' Creates an interactive heatmap, with each cell linked to
#' plots of horizontal and vertical slices
#'
#' @param x Vector of numeric values for the x-axis
#' @param y Vector of numeric values for the y-axis
#' @param z Numeric matrix of dim \code{length(x)} x \code{length(y)}
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details By default, the z-axis limits are from \code{-max(abs(z))}
#' to \code{max(abs(z))}, and negative cells are colored blue to white
#' which positive cells are colored white to red.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}
#'
#  Example function from Dmitry Pelinovsky
#  http://dmpeli.mcmaster.ca/Matlab/Math1J03/LectureNotes/Lecture2_5.htm
#' @examples
#' n <- 101
#' x <- y <- seq(-2, 2, len=n)
#' z <- matrix(ncol=n, nrow=n)
#' for(i in seq(along=x))
#'     for(j in seq(along=y))
#'         z[i,j] <- x[i]*y[j]*exp(-x[i]^2 - y[j]^2)
#' \donttest{
#' iheatmap(z, x, y)}
#'
#' @export
iheatmap <-
function(z, x, y, chartOpts=NULL)
{
    z <- as.matrix(z)
    if(missing(x) || is.null(x)) x <- 1:nrow(z)
    else stopifnot(length(x) == nrow(z))
    if(missing(y) || is.null(y)) y <- 1:ncol(z)
    else stopifnot(length(y) == ncol(z))
    names(x) <- names(y) <- dimnames(z) <- NULL

    # default height & width = 800 pixels
    chartOpts <- add2chartOpts(chartOpts, width=800, height=800)

    htmlwidgets::createWidget("iheatmap",
                              list(data=list(x=x, y=y, z=z), chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

#' @export
iheatmap_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iheatmap", width, height, package="qtlcharts")
}
#' @export
iheatmap_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iheatmap_output, env, quoted=TRUE)
}
