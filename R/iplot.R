## iplot
## Karl W Broman

#' Interactive scatterplot
#'
#' Creates an interactive scatterplot.
#'
#' @param x Numeric vector of x values
#' @param y Numeric vector of y values
#' @param group Optional vector of categories for coloring the points
#' @param indID Optional vector of character strings, shown with tool tips
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}, \code{\link{iplotCurves}}
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
function(x, y, group, indID, chartOpts=NULL)
{
    if(length(x) != length(y))
        stop("length(x) != length(y)")
    if(missing(group) || is.null(group))
        group <- rep(1, length(x))
    else if(length(group) != length(x))
        stop("length(group) != length(x)")
    if(missing(indID) || is.null(indID))
        indID <- as.character(seq(along=x))
    else if(length(indID) != length(x))
        stop("length(indID) != length(x)")
    indID <- as.character(indID)

    x <- list(data = data.frame(x=x, y=y, group=group, indID=indID),
              chartOpts=chartOpts)

    htmlwidgets::createWidget("iplot", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=800,
                                  browser.defaultHeight=500
                              ),
                              package="qtlcharts")
}

#' @export
iplot_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplot", width, height, package="qtlcharts")
}
#' @export
iplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplot_output, env, quoted=TRUE)
}
