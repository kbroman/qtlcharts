## idotplot
## Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param x Vector of groups of individuals (e.g., a genotype)
#' @param y Numeric vector (e.g., a phenotype)
#' @param indID Optional vector of character strings, shown with tool tips
#' @param group Optional vector of categories for coloring points
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
#' @seealso [iplot()], [iplotPXG()]
#'
#' @examples
#' n <- 100
#' g <- sample(LETTERS[1:3], n, replace=TRUE)
#' y <- rnorm(n, match(g, LETTERS[1:3])*10, 5)
#' \donttest{
#' idotplot(g, y)}
#'
#' @export
idotplot <-
function(x, y, indID=NULL, group=NULL, chartOpts=NULL, digits=5)
{
    stopifnot(length(x) == length(y))
    if(is.null(group)) group <- rep(1, length(x))
    stopifnot(length(group) == length(x))
    group <- group2numeric(group)
    if(is.null(indID))
        indID <- get_indID(length(x), names(x), names(y), names(group))
    stopifnot(length(indID) == length(x))
    indID <- as.character(indID)
    if(is.factor(x)) x_levels <- levels(x)
    else x_levels <- sort(unique(x))
    x <- group2numeric(x, preserveNA=TRUE)

    # strip off the names
    names(x) <- NULL
    names(y) <- NULL
    names(indID) <- NULL
    names(group) <- NULL

    chartOpts <- add2chartOpts(chartOpts, ylab="y", title="", xlab="group",
                               xcategories=seq(along=x_levels), xcatlabels=x_levels)

    x <- list(data=list(x=x, y=y, indID=indID, group=group), chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    defaultAspect <- 1 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("idotplot", x,
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
idotplot_output <- function(outputId, width="100%", height="530") {
    htmlwidgets::shinyWidgetOutput(outputId, "idotplot", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
idotplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, idotplot_output, env, quoted=TRUE)
}
