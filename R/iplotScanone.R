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
    file <- tempfile(tmpdir=tempdir(), fileext='.html')

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(!any(class(output) == "scanone"))
    stop('Input should have class "scanone".')

  if(lodcolumn < 1 || lodcolumn > ncol(output)-2)
    stop('lodcolumn must be between 1 and ', ncol(output)-2)

  output <- output[,c(1,2,lodcolumn+2), drop=FALSE]
  colnames(output)[3] <- 'lod'

  write_html_top(file, title=title)

  append_html_csslink(file, system.file('panels', 'lodchart', 'lodchart.css', package='qtlcharts'))
  append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'), 'utf-8')
  append_html_jslink(file, system.file('panels', 'lodchart', 'lodchart.js', package='qtlcharts'))
  append_html_jslink(file, system.file('charts', 'iplotScanone.js', package='qtlcharts'))

  append_html_middle(file, title, 'chart')
  
  append_html_jscode(file, 'data = ', scanone2json(output), ';\n\n', 'iplotScanone(data);')

  append_html_p(file, 'Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker for a bit of animation.', class='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
