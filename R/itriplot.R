## itriplot
## Karl W Broman

#' Interactive plot of trinomial probabilities
#'
#' Creates an interactive graph of trinomial probabilities,
#' represented as points within an equilateral triangle.
#'
#' @param p Matrix of trinomial probabilities (n x 3); each row should sum to 1.
#' @param indID Optional vector of character strings, shown with tool tips
#' @param group Optional vector of categories for coloring the points
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplot}}, \code{\link{iplotPXG}}, \code{\link{idotplot}}
#'
#' @examples
#' n <- 100
#' p <- matrix(runif(3*n), ncol=3)
#' p <- p / colSums(p)
#' g <- sample(1:3, n, replace=TRUE)
#' \donttest{
#' itriplot(p, group=g)}
#'
#' @export
itriplot <-
function(p, indID=NULL, group=NULL, chartOpts=NULL, digits=5)
{
    if(!is.matrix(p)) p <- as.matrix(p)
    stopifnot(ncol(p) == 3)
    n <- nrow(p)

    if(is.null(indID))
        indID <- get_indID(n, rownames(p), names(group))
    stopifnot(length(indID) == n)
    indID <- as.character(indID)

    if(is.null(group)) group <- rep(1, n)
    group_levels <- sort(unique(group))
    group <- group2numeric(group)

    dimnames(p) <- NULL # strip off the names
    names(group) <- NULL
    names(indID) <- NULL

    x <- list(data=list(p=p, indID=indID, group=group),
              chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    defaultAspect <- 2/sqrt(3) # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("itriplot", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize$width,
                                  browser.defaultHeight=browsersize$height,
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=1000/defaultAspect),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
itriplot_output <- function(outputId, width="100%", height="530") {
    htmlwidgets::shinyWidgetOutput(outputId, "itriplot", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
itriplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, itriplot_output, env, quoted=TRUE)
}
