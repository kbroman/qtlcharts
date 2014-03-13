# manyboxplots
# Karl W Broman

#' Modern boxplot linked to underlying histrograms
#'
#' Creates an interactive graph for a large set of box plots (rendered
#' as lines connecting the quantiles), linked to underlying histograms.
#'
#' @param dat Data matrix (individuals x variables)
#' @param qu Quantiles to plot (All with 0 < qu < 0.5)
#' @param orderByMedian If TRUE, reorder individuals by their median
#' @param breaks Number of break points in the histogram
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param legend Character vector with text for a legend (to be
#' combined to one string with \code{\link[base]{paste}}, with
#' \code{collapse=''})
#'
#' @return Character string with the name of the file created.
#' @export
#'
#' @examples
#' n.ind <- 500
#' n.gene <- 10000
#' expr <- matrix(rnorm(n.ind * n.gene, (1:n.ind)/n.ind*3), ncol=n.gene)
#' dimnames(expr) <- list(paste0("ind", 1:n.ind),
#'                        paste0("gene", 1:n.gene))
#' manyboxplots(expr)
manyboxplots <-
function(dat, qu = c(0.001, 0.01, 0.1, 0.25), orderByMedian=TRUE, breaks=251,
         file, onefile=FALSE, openfile=TRUE, title="Many box plots",
         legend)
{
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  json <- convert4manyboxplots(dat, qu, orderByMedian, breaks)

  # start writing
  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_chart('manyboxplots', file, onefile=onefile)

  append_html_middle(file, title, 'chart')

  if(missing(legend))
    legend <- c('Top panel is like a set of ', nrow(dat), ' box plots: ',
                'lines are drawn at a series of percentiles for each of the distributions. ',
                'Hover over a column in the top panel and the corresponding distribution ',
                'is show below; click for it to persist; click again to make it go away.')

  append_legend(legend, file)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_jscode(file, 'manyboxplots(data);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
