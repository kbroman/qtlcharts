# curves_w_2scatter.R
# Karl W Broman

#' Plot of a bunch of curves, linked to points in two scatterplots
#'
#' Creates an interactive graph with a panel having a number of curves
#' (say, a phenotype measured over time) linked to two scatter plots
#' (say, of the first vs middle and middle vs last times).
#' 
#' @param curveMatrix Matrix (dim n_ind x n_times) with outcomes
#' @param times Vector (length n_times) with time points for the columns of curveMatrix
#' @param scatter1 Matrix (dim n_ind x 2) with data for the first scatterplot
#' @param scatter2 Matrix (dim n_ind x 2) with data for the second scatterplot
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param legend Character vector with text for a legend (to be
#' combined to one string with \code{\link[base]{paste}}, with
#' \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#' the coffeescript code). Each element must be named using the
#' corresponding option.
#' @param \dots Additional arguments passed to the \code{\link[RJSONIO]{toJSON}} function
#' @return Character string with the name of the file created.
#' @export
#' @examples
#' # random growth curves, based on some data
#' times <- 1:16
#' n <- 100
#' start <- rnorm(n, 5.2, 0.8)
#' slope1to5 <- rnorm(n, 2.6, 0.5)
#' slope5to16 <- rnorm(n, 0.24 + 0.09*slope1to5, 0.195)
#' y <- matrix(ncol=16, nrow=n)
#' y[,1] <- start
#' for(j in 2:5)
#'   y[,j] <- y[,j-1] + slope1to5
#' for(j in 6:16)
#'   y[,j] <- y[,j-1] + slope5to16
#' y <- y + rnorm(prod(dim(y)), 0, 0.35)
#'
#' # Make the plot
#' curves_w_2scatter(y, times, y[,c(1,5)], y[,c(5,16)])
#' @seealso \code{\link{corr_w_scatter}}
curves_w_2scatter <- 
function(curveMatrix, times, scatter1, scatter2,
         file, onefile=FALSE, openfile=TRUE, title="", legend,
         chartOpts=NULL, ...)
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  n.ind <- nrow(curveMatrix)
  n.times <- ncol(curveMatrix)
  if(length(times) != n.times)
    stop("length(times) != ncol(curveMatrix)")
  if(nrow(scatter1) != n.ind)
    stop("nrow(scatter1) != nrow(curveMatrix)")
  if(nrow(scatter2) != n.ind)
    stop("nrow(scatter2) != nrow(curveMatrix)")

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panel('curvechart', file, onefile=onefile)
  link_panel('scatterplot', file, onefile=onefile)
  link_chart('curves_w_2scatter', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  dimnames(curveMatrix) <- names(times) <- dimnames(scatter1) <- dimnames(scatter2) <- NULL

  append_html_jscode(file, 'curve_data = ', toJSON(list(x=times, data=curveMatrix), ...), ';')
  append_html_jscode(file, 'scatter1_data = ', toJSON(scatter1, ...), ';')
  append_html_jscode(file, 'scatter2_data = ', toJSON(scatter2, ...), ';')

  jscode = paste0('mychart = curves_w_2scatter()', convertChartOpts(chartOpts), ';\n',
                  'd3.select("div#chart").datum({"curve_data":curve_data, ',
                  '"scatter1_data":scatter1_data, "scatter2_data":scatter2_data}).call(mychart);')
  append_html_jscode(file, jscode)

  if(missing(legend) || is.null(legend))
    legend <- c('Insert a legend here. ',
                'Really; I mean it!') 
  append_legend(legend, file)

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
