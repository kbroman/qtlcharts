## iplot
## Karl W Broman

#' Interactive scatterplot
#'
#' Creates an interactive scatterplot.
#'
#' @param x Numeric vector of x values
#' @param y Numeric vector of y values (If NULL, we take the `x` values as `y`, and use `1:length(x)` for `x`.)
#' @param group Optional vector of categories for coloring the points
#' @param indID Optional vector of character strings, shown with tool tips
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
#' @seealso [iplotCorr()], [iplotCurves()], [itriplot()],
#' [idotplot()], [iplotPXG()]
#'
#' @examples
#' x <- rnorm(100)
#' grp <- sample(1:3, 100, replace=TRUE)
#' y <- x*grp + rnorm(100)
#' \donttest{
#' iplot(x, y, grp)}
#'
#' @export
iplot <-
function(x, y=NULL, group=NULL, indID=NULL, chartOpts=NULL, digits=5)
{
    if(is.null(y)) {
        y <- x
        x <- seq_along(y)
        chartOpts <- add2chartOpts(chartOpts, xlab="Index")
    }
    if(length(x) != length(y))
        stop("length(x) != length(y)")
    if(is.null(group))
        group <- rep(1, length(x))
    else if(length(group) != length(x))
        stop("length(group) != length(x)")
    if(is.null(indID))
        indID <- get_indID(length(x), names(x), names(y), names(group))
    if(length(indID) != length(x))
        stop("length(indID) != length(x)")
    indID <- as.character(indID)
    group <- group2numeric(group) # convert to numeric
    names(x) <- names(y) <- NULL # strip names

    x <- list(data = data.frame(x=x, y=y, group=group, indID=indID),
              chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    defaultAspect <- 1.33 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("iplot", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize$width,
                                  browser.defaultHeight=browsersize$height
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplot_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplot", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplot_output, env, quoted=TRUE)
}
