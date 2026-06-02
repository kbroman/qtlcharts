## itimeplot
## Karl W Broman

#' Interactive scatterplot with date/time on x-axis
#'
#' Creates an interactive scatterplot with date/time on the x-axis.
#'
#' @param datetime Vector of date/time values
#' @param y Numeric vector of y values
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
#' n_pts <- 100
#' x <-  seq(as.POSIXct("1969-05-01"), as.POSIXct("1969-05-04"), length=n_pts)
#' grp <- sample(1:3, n_pts, replace=TRUE)
#' y <- rnorm(n_pts, grp) + rnorm(n_pts)
#' \donttest{
#' itimeplot(x, y, grp)
#' }
#'
#' # with shorter time span, times are shown instead of dates
#' x <-  seq(as.POSIXct("1969-05-01"), as.POSIXct("1969-05-02"), length=n_pts)
#' \donttest{
#' itimeplot(x, y, grp, chartOpts=list(xlab="Time"))
#' }
#'#'
#' @export
itimeplot <-
function(datetime, y, group=NULL, indID=NULL, chartOpts=NULL, digits=5)
{
    if(length(datetime) != length(y))
        stop("length(datetime) != length(y)")
    if(is.null(group))
        group <- rep(1, length(datetime))
    else if(length(group) != length(datetime))
        stop("length(group) != length(datetime)")
    if(is.null(indID))
        indID <- get_indID(length(datetime), names(datetime), names(y), names(group))
    if(length(indID) != length(datetime))
        stop("length(indID) != length(datetime)")
    indID <- as.character(indID)
    group <- group2numeric(group) # convert to numeric
    names(datetime) <- names(y) <- NULL # strip names

    chartOpts <- stripNames_chartOpts(chartOpts)

    x <- list(data = data.frame(x=datetime, y=y, group=group, indID=indID),
              chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    defaultAspect <- 1.33 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("itimeplot", x,
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
itimeplot_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplot", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
itimeplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, itimeplot_output, env, quoted=TRUE)
}
