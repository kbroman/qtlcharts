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
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
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
function(z, x, y, chartOpts=NULL, digits=5)
{
    z <- as.matrix(z)
    if(missing(x) || is.null(x)) x <- 1:nrow(z)
    else stopifnot(length(x) == nrow(z))
    if(missing(y) || is.null(y)) y <- 1:ncol(z)
    else stopifnot(length(y) == ncol(z))
    names(x) <- names(y) <- dimnames(z) <- NULL

    defaultAspect <- 1 # width/height
    browsersize <- getPlotSize(defaultAspect)

    dat <- list(data=list(x=x, y=y, z=z), chartOpts=chartOpts)
    if(!is.null(digits))
        attr(dat, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("iheatmap", dat,
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
iheatmap_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iheatmap", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iheatmap_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iheatmap_output, env, quoted=TRUE)
}
