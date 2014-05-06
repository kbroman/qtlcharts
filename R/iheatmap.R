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
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#' @param digits Number of digits in JSON; passed to \code{\link[jsonlite]{toJSON}}
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
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
#' @importFrom jsonlite toJSON
#' @export
iheatmap <-
function(z, x, y,
         file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart',
         caption, chartOpts=NULL, digits=4, print=FALSE)
{
  if(missing(file)) file <- NULL

  z <- as.matrix(z)
  if(missing(x) || is.null(x)) x <- 1:nrow(z)
  else stopifnot(length(x) == nrow(z))
  if(missing(y) || is.null(y)) y <- 1:ncol(z)
  else stopifnot(length(y) == ncol(z))
  names(x) <- names(y) <- dimnames(z) <- NULL
  json <- strip_whitespace( toJSON(list(x=x, y=y, z=z), digits=digits) )

  if(missing(caption) || is.null(caption))
    caption <- c('Hover over pixels in the heatmap on the top-left to see the values and to see ',
                 'the horizontal slice (below) and the vertical slice (to the right).')

  file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                    panels=c("curvechart", "heatmap"), charts="iheatmap",
                    chartdivid=chartdivid, caption=caption, print=print)

  # add chartdivid to chartOpts
  chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iheatmap(data, chartOpts);')

  append_html_bottom(file, print=print)

  if(openfile && !print) browseURL(file)

  invisible(file)
}
