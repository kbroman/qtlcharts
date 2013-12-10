# iplotPXG
# Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param cross (Optional) Object of class \code{"cross"}, see \code{\link[qtl]{read.cross}}.
#' @param marker Character string with marker name
#' @param pheno.col (Optional) Phenotype column in cross object.
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param method Method for imputing missing genotypes
#' @param error.prob Genotyping error probability used in imputing missing genotypes
#' @param map.function Map function used in imputing missing genotypes
#' @param \dots Passed to \cite{\link[RJSONIO]{toJSON}}
#' @return Character string with the name of the file created
#' @export
#' @examples
#' \dontrun{
#' data(hyper)
#' marker <- sample(markernames(hyper), 1)
#' iplotPXG(hyper, marker)
#' }
#' @seealso \code{\link{iplotScanone}}
iplotPXG <-
function(cross, marker, pheno.col=1,
         file, onefile=FALSE, openfile=TRUE, title="",
         method=c("imp", "argmax", "no_dbl_XO"), error.prob=0.0001,
         map.function=c("haldane", "kosambi", "c-f", "morgan"), ...)
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(class(cross)[2] != "cross")
    stop('"cross" should have class "cross".')
  
  write_html_top(file, title=title)

  append_html_csslink(file, system.file('panels', 'dotchart', 'dotchart.css', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'), 'utf-8', onefile=onefile)
  append_html_jslink(file, system.file('panels', 'dotchart', 'dotchart.js', package='qtlcharts'), onefile=onefile)
  append_html_jslink(file, system.file('charts', 'iplotPXG.js', package='qtlcharts'), onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  method <- match.arg(method)
  map.function <- match.arg(map.function)
  json <- pxg2json(pull.markers(cross, marker), pheno.col, method, error.prob, map.function, ...)
  append_html_jscode(file, 'data = ', json, ';\n\n', 'iplotPXG(data);')

  append_html_p(file, 'Click on a point for a bit of gratuitous animation.', class='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
