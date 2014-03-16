# iplotPXG
# Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param cross (Optional) Object of class \code{"cross"}, see
#'   \code{\link[qtl]{read.cross}}.
#' @param marker Character string with marker name.
#' @param pheno.col (Optional) Phenotype column in cross object.
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
#' @param fillgenoArgs List of named arguments to pass to
#'   \code{\link[qtl]{fill.geno}}, if needed.
#' @param ... Passed to \cite{\link[RJSONIO]{toJSON}}.
#'
#' @return Character string with the name of the file created.
#'
#' @details The function \code{\link[qtl]{fill.geno}} is used to
#' impute missing genotypes, with arguments passed as a list, for
#' example \code{fillgenoArgs=list(method="argmax", error.prob=0.002,
#' map.function="c-f")}.
#'
#' Individual IDs (viewable when hovering over a point) are taken from
#' the input \code{cross} object, using the \code{\link[qtl]{getid}}
#' function in R/qtl.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}
#'
#' @examples
#' data(hyper)
#' marker <- sample(markernames(hyper), 1)
#' iplotPXG(hyper, marker)
#'
#' @export
iplotPXG <-
function(cross, marker, pheno.col=1,
         file, onefile=FALSE, openfile=TRUE, title="",
         caption, chartOpts=list(title=marker[1]),
         fillgenoArgs=NULL, ...)
{    
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(class(cross)[2] != "cross")
    stop('"cross" should have class "cross".')
  
  if(length(marker) > 1) {
    marker <- marker[1]
    warning('marker should have length 1; using "', marker, '"')
  }

  filetitle <- ifelse(title=="", marker, title)
  write_html_top(file, title=filetitle)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('dotchart', file, onefile=onefile)
  link_chart('iplotPXG', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(caption))
    caption <- c('Pink points correspond to individuals with imputed genotypes at this marker. ',
                'Click on a point for a bit of gratuitous animation.')
  append_caption(caption, file)

  json <- pxg2json(pull.markers(cross, marker), pheno.col, fillgenoArgs=fillgenoArgs, ...)

  # use phenotype name as y-axis label, unless ylab is already provided
  chartOpts <- add2chartOpts(chartOpts, ylab=getPhename(cross, pheno.col=pheno.col))
  print(chartOpts)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iplotPXG(data,chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}

getPhename <-
function(cross, pheno.col)
{
  if(is.character(pheno.col)) return(pheno.col)
  names(cross$pheno)[pheno.col]
}
