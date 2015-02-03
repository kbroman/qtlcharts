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
#'     locations of the breakpoints between bins (as in \code{\link[graphics]{hist}})
#' @param chartOpts A list of options for configuring the chart (see
#'     the coffeescript code). Each element must be named using the
#'     corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}
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
         chartOpts=NULL)
{
    data_list <- convert4iboxplot(dat, qu, orderByMedian, breaks)

    # use default height of 1000 pixels
    chartOpts <- add2chartOpts(chartOpts, height=1000)

    htmlwidgets::createWidget("iboxplot", list(data=data_list, chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

#' @export
iboxplot_output <- function(outputId, width="100%", height="900") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplot", width, height, package="qtlcharts")
}
#' @export
iboxplot_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplot_output, env, quoted=TRUE)
}
