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
#' @param file Optional character vector with file to contain the
#'     output
#' @param onefile If TRUE, have output file contain all necessary
#'     javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'     combined to one string with \code{\link[base]{paste}}, with
#'     \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#'     the coffeescript code). Each element must be named using the
#'     corresponding option.
#' @param digits Number of digits in JSON; pass to
#'     \code{\link[jsonlite]{toJSON}}
#' @param print If TRUE, print the output, rather than writing it to a file,
#'     for use within an R Markdown document.
#'
#' @return Character string with the name of the file created.
#'
#' @importFrom utils browseURL
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
#' iboxplot(expr, title="iboxplot example",
#'          chartOpts=list(xlab="Mice", ylab="Gene expression"))
#'
#' @export
iboxplot <-
function(dat, qu = c(0.001, 0.01, 0.1, 0.25), orderByMedian=TRUE, breaks=251,
         file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart', caption, chartOpts=NULL, digits=4, print=FALSE)
{
    if(missing(file)) file <- NULL

    json <- convert4iboxplot(dat, qu, orderByMedian, breaks, digits)

    if(missing(caption) || is.null(caption))
        caption <- c('The top panel is like a set of ', nrow(dat), ' box plots: ',
                     'lines are drawn at a series of percentiles for each of the distributions. ',
                     'Hover over a column in the top panel and the corresponding distribution ',
                     'is show below; click for it to persist; click again to make it go away.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels=NULL, charts="iboxplot", chartdivid=chartdivid,
                      caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_data = '), json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iboxplot(', chartdivid, '_data, ', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}
