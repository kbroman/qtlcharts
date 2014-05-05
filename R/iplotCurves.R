## iplotCurves.R
## Karl W Broman

#' Plot of a bunch of curves, linked to points in scatterplots
#'
#' Creates an interactive graph with a panel having a number of curves
#' (say, a phenotype measured over time) linked to one or two (or no) scatter plots
#' (say, of the first vs middle and middle vs last times).
#' 
#' @param curveMatrix Matrix (dim n_ind x n_times) with outcomes
#' @param times Vector (length n_times) with time points for the
#'   columns of curveMatrix
#' @param scatter1 Matrix (dim n_ind x 2) with data for the first
#'   scatterplot
#' @param scatter2 Matrix (dim n_ind x 2) with data for the second
#'   scatterplot
#' @param group Optional vector of groups of individuals (e.g., a genotype)
#' @param file Optional character vector with file to contain the
#'   output
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#' @param ... Additional arguments passed to the
#'   \code{\link[jsonlite]{toJSON}} function
#'
#' @return Character string with the name of the file created.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}
#'
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
#' iplotCurves(y, times, y[,c(1,5)], y[,c(5,16)],
#'                  title = "iplotCurves example",
#'                  chartOpts=list(curves_xlab="Time", curves_ylab="Size",
#'                                 scat1_xlab="Size at T=1", scat1_ylab="Size at T=5",
#'                                 scat2_xlab="Size at T=5", scat2_ylab="Size at T=16"))
#'
#' @export
#' @importFrom jsonlite toJSON
iplotCurves <- 
function(curveMatrix, times, scatter1=NULL, scatter2=NULL, group=NULL,
         file, onefile=FALSE, openfile=TRUE, title="", caption,
         chartOpts=NULL, ...)
{    
  if(missing(file) || is.null(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  n.ind <- nrow(curveMatrix)
  n.times <- ncol(curveMatrix)
  if(missing(times) || is.null(times)) times <- 1:ncol(curveMatrix)
  if(length(times) != n.times)
    stop("length(times) != ncol(curveMatrix)")
  if(!is.null(scatter1) && nrow(scatter1) != n.ind)
    stop("nrow(scatter1) != nrow(curveMatrix)")
  if(!is.null(scatter2) && nrow(scatter2) != n.ind)
    stop("nrow(scatter2) != nrow(curveMatrix)")
  if(is.null(scatter1) && !is.null(scatter2)) {
    scatter1 <- scatter2
    scatter2 <- NULL
  }
  if(!is.null(group) && length(group) != n.ind) {
    stop("length(group) != nrow(curveMatrix)")
    if(any(group <= 0)) stop("group values should be >= 0")
  }
  indID <- rownames(curveMatrix)
  
  if(is.data.frame(curveMatrix)) curveMatrix <- as.matrix(curveMatrix)
  if(is.data.frame(scatter1)) scatter1 <- as.matrix(scatter1)
  if(is.data.frame(scatter2)) scatter2 <- as.matrix(scatter2)
  dimnames(curveMatrix) <- dimnames(scatter1) <- dimnames(scatter2) <- names(group) <- names(times) <- NULL

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_colorbrewer(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('curvechart', file, onefile=onefile)
  link_panel('scatterplot', file, onefile=onefile)
  link_chart('iplotCurves', file, onefile=onefile)

  append_html_middle(file, title, 'chart')

  if(missing(caption) || is.null(caption)) {
    if(is.null(scatter1)) # no scatterplots
      caption <- 'Hover over a curve to have it highlighted.'
    else if(is.null(scatter2)) # one scatterplot
      caption <- c('The curves are linked to the scatterplot below: ',
                  'hover over an element in one panel, ',
                  'and the corresponding element in the other panel will be highlighted.')
    else
      caption <- c('The curves are linked to the two scatterplots below: ',
                  'hover over an element in one panel, ',
                  'and the corresponding elements in the other panels will be highlighted.')
  }
  append_caption(caption, file)

  append_html_jscode(file, 'curve_data = ', toJSON(list(x=times, data=curveMatrix, group=group, indID=indID), ...), ';')
  scat1_json <- ifelse(is.null(scatter1), toJSON(NULL, container=FALSE),
                       toJSON(list(data=scatter1, group=group, indID=indID), ...))
  append_html_jscode(file, 'scatter1_data = ', scat1_json, ';')
  scat2_json <- ifelse(is.null(scatter2), toJSON(NULL, container=FALSE),
                       toJSON(list(data=scatter2, group=group, indID=indID), ...))
  append_html_jscode(file, 'scatter2_data = ', scat2_json, ';')
  append_html_chartopts(file, chartOpts)

  append_html_jscode(file, 'iplotCurves(curve_data, scatter1_data, scatter2_data, chartOpts)')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
