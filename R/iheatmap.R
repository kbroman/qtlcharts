## iheatmap
## Karl W Broman

#' Interactive heat map
#'
#' Creates an interactive heatmap, with each cell linked to
#' plots of horizontal and vertical slices
#'
#' @param x Vector of numeric values for the x-axis
#' @param y Vector of numeric values for the y-axis
#' @param z Numeric matrix of dim \code{length(x)} x \code{length(y)}
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
#'
#' @return Character string with the name of the file created.
#'
#' @details By default, the z-axis limits are from \code{-max(abs(z))}
#' to \code{max(abs(z))}, and negative cells are colored blue to white
#' which positive cells are colored white to red.
#'
#' @importFrom utils browseURL
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}
#' 
#  Example function from Dmitry Pelinovsky
#  http://dmpeli.mcmaster.ca/Matlab/Math1J03/LectureNotes/Lecture2_5.htm
#' @examples
#' n <- 101
#' x <- y <- seq(-2, 2, len=n)
#' z <- matrix(ncol=n, nrow=n)
#' for(i in seq(along=x))
#'   for(j in seq(along=y))
#'     z[i,j] <- x[i]*y[j]*exp(-x[i]^2 - y[j]^2)
#' iheatmap(z, x, y, title = "iheatmap example")
#' @importFrom RJSONIO toJSON
#' @export
iheatmap <-
function(z, x, y,
         file, onefile=FALSE, openfile=TRUE, title="",
         caption, chartOpts=NULL)
{
  if(missing(file) || is.null(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  z <- as.matrix(z)
  if(missing(x) || is.null(x)) x <- 1:nrow(z)
  else stopifnot(length(x) == nrow(z))
  if(missing(y) || is.null(y)) y <- 1:ncol(z)
  else stopifnot(length(y) == ncol(z))
  names(x) <- names(y) <- dimnames(z) <- NULL
  json <- toJSON(list(x=x, y=y, z=z))

  # start writing
  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('curvechart', file, onefile=onefile)
  link_panel('heatmap', file, onefile=onefile)
  link_chart('iheatmap', file, onefile=onefile)

  append_html_middle(file, title, 'chart')

  if(missing(caption) || is.null(caption))
    caption <- c('Hover over pixels in the heatmap on the top-left to see the values and to see ',
                 'the horizontal slice (below) and the vertical slice (to the right).')
  append_caption(caption, file)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iheatmap(data, chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
