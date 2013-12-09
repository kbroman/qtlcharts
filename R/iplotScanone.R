# iplotScanone
# Karl W Broman

#' Interactive LOD curve
#
#' @param scanoneOutput Object of class \code{"scanone"}, as output from \code{\link[qtl]{scanone}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot.
#' @param cross (Optional) Object of class \code{"cross"}, see \code{\link[qtl]{read.cross}}.
#' @param pheno.col (Optional) Phenotype column in cross object.
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
#' \dontrun{iplotScanone(out, cross=hyper)}
iplotScanone <-
function(scanoneOutput, lodcolumn=1, cross, pheno.col=1, 
         file, onefile=FALSE, openfile=TRUE, title="")
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(!any(class(scanoneOutput) == "scanone"))
    stop('"scanoneOutput" should have class "scanone".')

  if(lodcolumn < 1 || lodcolumn > ncol(scanoneOutput)-2)
    stop('lodcolumn must be between 1 and ', ncol(scanoneOutput)-2)

  scanoneOutput <- scanoneOutput[,c(1,2,lodcolumn+2), drop=FALSE]
  colnames(scanoneOutput)[3] <- 'lod'

  if(missing(cross))
    return(iplotScanone_noeff(scanoneOutput=scanoneOutput, file=file, onefile=onefile,
                              openfile=openfile, title=title))

  if(class(cross)[2] != "cross")
    stop('"cross" should have class "cross".')
  
  iplotScanone_pxg(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                   file=file, onefile=onefile, openfile=openfile, title=title)

  invisible(file)
}


# iplotScanone, with just the LOD curve
iplotScanone_noeff <-
function(scanoneOutput, file, onefile=FALSE, openfile=TRUE, title)
{    
  write_html_top(file, title=title)

  append_html_csslink(file, system.file('panels', 'lodchart', 'lodchart.css', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'), 'utf-8', onefile=onefile)
  append_html_jslink(file, system.file('panels', 'lodchart', 'lodchart.js', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('charts', 'iplotScanone_noeff.js', package='qtlcharts'), onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  append_html_jscode(file, 'data = ', scanone2json(scanoneOutput), ';\n\n', 'iplotScanone_noeff(data);')

  append_html_p(file, 'Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker for a bit of gratuitous animation.', class='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}


# iplotScanone, with LOD curve and phe x gen
iplotScanone_pxg <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE, title)
{    
  write_html_top(file, title=title)

  append_html_csslink(file, system.file('panels', 'lodchart', 'lodchart.css', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'), 'utf-8', onefile=onefile)
  append_html_jslink(file, system.file('panels', 'lodchart', 'lodchart.js', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('charts', 'iplotScanone_noeff.js', package='qtlcharts'), onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  append_html_jscode(file, 'data = ', scanone2json(scanoneOutput), ';\n\n', 'iplotScanone_noeff(data);')

  append_html_p(file, 'Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker for a bit of gratuitous animation.', class='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
