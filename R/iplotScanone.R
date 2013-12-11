# iplotScanone
# Karl W Broman

#' Interactive LOD curve
#'
#' Creates an interactive graph of a single-QTL genome scan, as
#' calculated by \code{\link[qtl]{scanone}}. If \code{cross} is
#' provided, the LOD curves are linked to a phenotype x genotype plot
#' for a marker: Click on a marker on the LOD curve and see the
#' corresponding phenotype x genotype plot.
#' 
#' @param scanoneOutput Object of class \code{"scanone"}, as output from \code{\link[qtl]{scanone}}.
#' @param cross (Optional) Object of class \code{"cross"}, see \code{\link[qtl]{read.cross}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot.
#' @param pheno.col (Optional) Phenotype column in cross object.
#' @param chr (Optional) Optional vector indicating the chromosomes
#'            for which LOD scores should be calculated. This should be a vector
#'            of character strings referring to chromosomes by name; numeric
#'            values are converted to strings. Refer to chromosomes with a
#'            preceding - to have all chromosomes but those considered. A logical
#'            (TRUE/FALSE) vector may also be used.
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param method Method for imputing missing genotypes, if \code{\link[qtl]{fill.geno}} is needed.
#' @param error.prob Genotyping error probability used in imputing
#'        missing genotypes, if \code{\link[qtl]{fill.geno}} is needed.
#' @param map.function Map function used in imputing missing genotypes, if \code{\link[qtl]{fill.geno}} is needed.
#' @param \dots Additional arguments passed to the \code{\link[RJSONIO]{toJSON}} function
#' @return Character string with the name of the file created.
#' @export
#' @examples
#' data(hyper)
#' hyper <- calc.genoprob(hyper, step=1)
#' out <- scanone(hyper)
#' iplotScanone(out, hyper)
#' @seealso \code{\link{iplotPXG}}
iplotScanone <-
function(scanoneOutput, cross, lodcolumn=1, pheno.col=1, chr,
         file, onefile=FALSE, openfile=TRUE, title="",
         method=c("imp", "argmax", "no_dbl_XO"), error.prob=0.0001,
         map.function=c("haldane", "kosambi", "c-f", "morgan"), ...)
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(!any(class(scanoneOutput) == "scanone"))
    stop('"scanoneOutput" should have class "scanone".')

  if(lodcolumn < 1 || lodcolumn > ncol(scanoneOutput)-2)
    stop('lodcolumn must be between 1 and ', ncol(scanoneOutput)-2)

  scanoneOutput <- scanoneOutput[,c(1,2,lodcolumn+2), drop=FALSE]
  colnames(scanoneOutput)[3] <- 'lod'

  if(!missing(chr)) {
     scanoneOutput <- subset(scanoneOutput, chr=chr)
    if(!missing(cross)) cross <- subset(cross, chr=chr)
   }

  if(missing(cross))
    return(iplotScanone_noeff(scanoneOutput=scanoneOutput, file=file, onefile=onefile,
                              openfile=openfile, title=title, ...))

  if(class(cross)[2] != "cross")
    stop('"cross" should have class "cross".')
  
  method <- match.arg(method)
  map.function <- match.arg(map.function)
  iplotScanone_pxg(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                   file=file, onefile=onefile, openfile=openfile, title=title, 
                   method=method, error.prob=error.prob, map.function=map.function, ...)

  invisible(file)
}


# iplotScanone: LOD curves with nothing else
iplotScanone_noeff <-
function(scanoneOutput, file, onefile=FALSE, openfile=TRUE, title, ...)
{    
  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_chart('iplotScanone_noeff', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  append_html_jscode(file, 'data = ', scanone2json(scanoneOutput, ...), ';')
  append_html_jscode(file, 'iplotScanone_noeff(data);')

  append_html_p(file, 'Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker for a bit of gratuitous animation.',
                tag='div', class='legend', id='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}


# iplotScanone_pxg: LOD curves with linked phe x gen plot
iplotScanone_pxg <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE, title,
         method=c("imp", "argmax", "no_dbl_XO"), error.prob=0.0001,
         map.function=c("haldane", "kosambi", "c-f", "morgan"), ...)
{    
  scanone_json = scanone2json(scanoneOutput, ...)
  method <- match.arg(method)
  map.function <- match.arg(map.function)
  pxg_json = pxg2json(cross, pheno.col, method=method, error.prob=error.prob, map.function=map.function, ...)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_panel('dotchart', file, onefile=onefile)
  link_chart('iplotScanone_pxg', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  append_html_jscode(file, 'scanoneData = ', scanone_json, ';')
  append_html_jscode(file, 'pxgData = ', pxg_json, ';')
  append_html_jscode(file, 'iplotScanone_pxg(scanoneData, pxgData);')

  append_html_p(file, 'Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker to view the phenotype x genotype plot on the right.',
                tag='div', class='legend', id='legend')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
