## iplotMap
## Karl W Broman

#' Interactive genetic map plot
#'
#' Creates an interactive graph of a genetic marker map.
#'
#' @param map Object of class \code{"map"}, a list with each component
#'   being a vector of marker positions.
#' @param shift If TRUE, shift each chromsome so that the initial marker
#'   is at position 0.
#' @param file Optional character vector with file to contain the
#'   output.
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code.
#' @param openfile If TRUE, open the plot in the default web browser.
#' @param title Character string with title for plot.
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option. See details.
#' @param ... Passed to \cite{\link[RJSONIO]{toJSON}}.
#'
#' @return Character string with the name of the file created.
#'
#' @importFrom utils browseURL
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotPXG}}
#'
#' @examples
#' data(hyper)
#' map <- pull.map(hyper)
#' iplotMap(map, shift=TRUE, title="iplotMap example")
#'
#' @export
iplotMap <-
function(map, shift=FALSE, file, onefile=FALSE, openfile=TRUE, title="Genetic map",
         caption, chartOpts=NULL, ...)
{    
  if(missing(file) || is.null(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('mapchart', file, onefile=onefile)
  link_chart('iplotMap', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(caption) || is.null(caption))
    caption <- 'Hover over marker positions to view the marker names.'
  append_caption(caption, file)

  if(shift) map <- shiftmap(map)
  json <- map2json(map, ...)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iplotMap(data,chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
