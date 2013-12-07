# iplotScanone
# Karl W Broman

#' Interactive LOD curve
#
#' @param output Object of class \code{"scanone"}, as output from \code{\link[qtl]{scanone}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @return Character string with the name of the file created
#' @export
#' @examples
#' data(hyper)
#' hyper <- calc.genoprob(hyper)
#' out <- scanone(hyper, method="hk")
#' \dontrun{iplotScanone(out)}
#' \dontshow{iplotScanone(out, openfile=FALSE)}
iplotScanone <-
function(output, lodcolumn=1, file, onefile=FALSE, openfile=TRUE,
         title="LOD curve")
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext=".html")

  write_html_top(file, title=title)

  # append csslink
  # append d3 link
  # append lodchart link

  append_html_middle(file, title, "chart")
  
  # append iplotScanone script
  # append data

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
