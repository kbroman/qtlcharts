## iboxplot
## Karl W Broman

#' Modern boxplot linked to underlying histrograms
#'
#' Creates an interactive graph for a large set of box plots (rendered
#' as lines connecting the quantiles), linked to underlying histograms.
#'
#' @param dat Data matrix (individuals x variables)
#' @param qu Quantiles to plot (All with 0 < qu < 0.5)
#' @param orderByMedian If TRUE, reorder individuals by their median
#' @param breaks Number of bins in the histograms, or a vector of
#'     locations of the breakpoints between bins (as in [graphics::hist()])
#' @param chartOpts A list of options for configuring the chart (see
#'     the coffeescript code). Each element must be named using the
#'     corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso [iplotCorr()], [scat2scat()]
#'
#' @examples
#' n.ind <- 500
#' n.gene <- 10000
#' expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
#' dimnames(expr) <- list(paste0("ind", 1:n.ind),
#'                        paste0("gene", 1:n.gene))
#' \donttest{
#' iboxplot(expr, chartOpts=list(xlab="Mice", ylab="Gene expression"))}
#'
#' @export
iboxplot <-
function(dat, qu = c(0.001, 0.01, 0.1, 0.25), orderByMedian=TRUE, breaks=251,
         chartOpts=NULL, digits=5)
{
    data_list <- convert4iboxplot(dat, qu, orderByMedian, breaks)

    defaultAspect <- 1.25 # width/height
    browsersize <- getPlotSize(defaultAspect)

    x <- list(data=data_list, chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("iboxplot", x,
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
iboxplot_output <- function(outputId, width="100%", height="900") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplot", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iboxplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplot_output, env, quoted=TRUE)
}
