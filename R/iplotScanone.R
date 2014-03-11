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
#' @param pxgtype If phenotype x genotype plot is to be shown, should it be with
#'                means \eqn{\pm}{+/-} 2 SE (\code{"ci"}), or raw phenotypes (\code{"raw"})?
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param legend Character vector with text for a legend (to be
#' combined to one string with \code{\link[base]{paste}}, with
#' \code{collapse=''})
#' @param fillgenoArgs List of named arguments to pass to \code{\link[qtl]{fill.geno}}, if needed.
#' @param \dots Additional arguments passed to the \code{\link[RJSONIO]{toJSON}} function
#' @return Character string with the name of the file created.
#' @details If \code{cross} is provided, \code{\link[qtl]{fill.geno}}
#' is used to impute missing genotypes. In this case, arguments to
#' \code{\link[qtl]{fill.geno}} are passed as a list, for example
#' \code{fillgenoArgs=list(method="argmax", error.prob=0.002, map.function="c-f")}.
#' @export
#' @examples
#' data(hyper)
#' hyper <- calc.genoprob(hyper, step=1)
#' out <- scanone(hyper)
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15))
#' @seealso \code{\link{iplotPXG}}
iplotScanone <-
function(scanoneOutput, cross, lodcolumn=1, pheno.col=1, chr,
         pxgtype = c("ci", "raw"),
         file, onefile=FALSE, openfile=TRUE, title="", legend,
         fillgenoArgs=NULL, ...)
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)
  pxgtype <- match.arg(pxgtype)

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

  if(missing(legend)) legend <- NULL

  if(missing(cross))
    return(iplotScanone_noeff(scanoneOutput=scanoneOutput, file=file, onefile=onefile,
                              openfile=openfile, title=title, legend=legend, ...))

  if(class(cross)[2] != "cross")
    stop('"cross" should have class "cross".')
  
  if(pxgtype == "raw")
    iplotScanone_pxg(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                     file=file, onefile=onefile, openfile=openfile, title=title, legend=legend,
                     fillgenoArgs=fillgenoArgs, ...)

  else
    iplotScanone_ci(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                    file=file, onefile=onefile, openfile=openfile, title=title, legend=legend,
                    fillgenoArgs=fillgenoArgs, ...)

  invisible(file)
}


# iplotScanone: LOD curves with nothing else
iplotScanone_noeff <-
function(scanoneOutput, file, onefile=FALSE, openfile=TRUE, title, legend, ...)
{    
  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_chart('iplotScanone_noeff', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(legend) || is.null(legend))
    legend <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker for a bit of gratuitous animation.')
  append_legend(legend, file)

  append_html_jscode(file, 'data = ', scanone2json(scanoneOutput, ...), ';')
  append_html_jscode(file, 'iplotScanone_noeff(data);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}


# iplotScanone_pxg: LOD curves with linked phe x gen plot
iplotScanone_pxg <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE, title,
         legend, fillgenoArgs=NULL, ...)
{    
  scanone_json = scanone2json(scanoneOutput, ...)
  pxg_json = pxg2json(cross, pheno.col, fillgenoArgs=fillgenoArgs, ...)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_panel('dotchart', file, onefile=onefile)
  link_chart('iplotScanone_pxg', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(legend) || is.null(legend))
    legend <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker to view the phenotype x genotype plot on the right. ',
                'In the phenotype x genotype plot, the intervals indicate the mean &plusmn; 2 SE.')
  append_legend(legend, file)

  append_html_jscode(file, 'scanoneData = ', scanone_json, ';')
  append_html_jscode(file, 'pxgData = ', pxg_json, ';')
  append_html_jscode(file, 'iplotScanone_pxg(scanoneData, pxgData);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}

# iplotScanone_ci: LOD curves with linked phe mean +/- 2 SE x gen plot
iplotScanone_ci <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE, title,
         legend, fillgenoArgs=NULL, ...)
{    
  scanone_json = scanone2json(scanoneOutput, ...)
  pxg_json = pxg2json(cross, pheno.col, fillgenoArgs=fillgenoArgs, ...)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_panel('cichart', file, onefile=onefile)
  link_chart('iplotScanone_ci', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(legend) || is.null(legend))
    legend <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                'Click on a marker to view the phenotype x genotype plot on the right. ',
                'In the phenotype x genotype plot, the intervals indicate the mean &plusmn; 2 SE.')
  append_legend(legend, file)

  append_html_jscode(file, 'scanoneData = ', scanone_json, ';')
  append_html_jscode(file, 'pxgData = ', pxg_json, ';')
  append_html_jscode(file, 'iplotScanone_ci(scanoneData, pxgData);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
