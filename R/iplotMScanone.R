## iplotMScanone
## Karl W Broman

#' Interactive LOD curve
#'
#' Creates an interactive graph of a set of single-QTL genome scans, as
#' calculated by \code{\link[qtl]{scanone}}. If \code{cross} or
#' \code{effects} are provide, LOD curves will be linked to a panel
#' with estimated QTL effects.
#' 
#' @param scanoneOutput Object of class \code{"scanone"}, as output
#'   from \code{\link[qtl]{scanone}}.
#' @param cross (Optional) Object of class \code{"cross"}, see
#'   \code{\link[qtl]{read.cross}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot.
#' @param pheno.col (Optional) Phenotype column in cross object.
#' @param effects (Optional)
#' @param chr (Optional) Optional vector indicating the chromosomes
#'   for which LOD scores should be calculated. This should be a vector
#'   of character strings referring to chromosomes by name; numeric
#'   values are converted to strings. Refer to chromosomes with a
#'   preceding - to have all chromosomes but those considered. A logical
#'   (TRUE/FALSE) vector may also be used.
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
#' @param ... Additional arguments passed to the
#'   \code{\link[RJSONIO]{toJSON}} function
#'
#' @return Character string with the name of the file created.
#'
#' @details If \code{cross} is provided, Haley-Knott regression is
#' used to estimate QTL effects at each pseudomarker.
#'
#' @importFrom utils browseURL
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}
#'
#' @examples
#' data(grav)
#' grav <- calc.genoprob(grav, step=1)
#' grav <- reduce2grid(grav)
#' out <- scanone(grav, phe=seq(1, nphe(grav), by=5), method="hk")
#' iplotMScanone(out, title="iplotMScanone example, no effects")
#'
#' eff <- estQTLeffects(grav, phe=seq(1, nphe(grav), by=5), what="effects")
#' iplotMScanone(out, effects=eff, title="iplotMScanone example, with effects",
#'               chartOpts=list(eff_ylab="QTL effect"))
#'
#' @export
iplotMScanone <-
function(scanoneOutput, cross, lodcolumn, pheno.col,
         effects, chr,
         file, onefile=FALSE, openfile=TRUE, title="", caption,
         chartOpts=NULL, ...)
{    
  if(missing(file) || is.null(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)
  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(!any(class(scanoneOutput) == "scanone"))
    stop('"scanoneOutput" should have class "scanone".')

  if(!missing(chr) && !is.null(chr)) {
    rn <- rownames(scanoneOutput)
    scanoneOutput <- subset(scanoneOutput, chr=chr)
    if(!missing(effects) && !is.null(effects)) effects <- effects[match(rownames(scanoneOutput), rn)]
    if(!missing(cross) && !is.null(cross)) cross <- subset(cross, chr=chr)
   }

  if(missing(caption) || is.null(caption)) caption <- NULL

  if(missing(lodcolumn) || is.null(lodcolumn)) lodcolumn <- 1:(ncol(scanoneOutput)-2)
  stopifnot(all(lodcolumn >= 1 & lodcolumn <= ncol(scanoneOutput)-2))
  scanoneOutput <- scanoneOutput[,c(1,2,lodcolumn+2),drop=FALSE]

  if(missing(pheno.col) || is.null(pheno.col)) pheno.col <- seq(along=lodcolumn)
  if((missing(cross) || is.null(cross)) && (missing(effects) || is.null(effects)))
     return(iplotMScanone_noeff(scanoneOutput,
                                file=file, onefile=onefile, openfile=openfile, title=title,
                                caption=caption, chartOpts=chartOpts, ...))

  if(missing(effects) || is.null(effects)) {
    stopifnot(length(pheno.col) == length(lodcolumn))
    stopifnot(class(cross)[2] == "cross")

    crosstype <- class(cross)[1]
    handled_crosses <- c("bc", "bcsft", "dh", "riself", "risib", "f2", "haploid") # handled for add/dom effects
    what <- ifelse(crosstype %in% handled_crosses, "effects", "means")
    effects <- estQTLeffects(cross, pheno.col, what=what)
  }

  stopifnot(length(effects) == nrow(scanoneOutput))
  stopifnot(all(vapply(effects, nrow, 1) == ncol(scanoneOutput)-2))

  scanoneOutput <- calcSignedLOD(scanoneOutput, effects)

  iplotMScanone_eff(scanoneOutput, effects,
                    file=file, onefile=onefile, openfile=openfile, title=title,
                    caption=caption, chartOpts=chartOpts, ...)
}


# iplotMScanone_noeff: multiple LOD curves; no QTL effects
iplotMScanone_noeff <-
function(scanoneOutput,
         file, onefile=FALSE, openfile=TRUE,
         title="", caption, chartOpts=NULL, ...)
{
  scanone_json <- scanone2json(scanoneOutput, ...)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('lodheatmap', file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_panel('curvechart', file, onefile=onefile)
  link_chart('iplotMScanone_noeff', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(caption) || is.null(caption))
    caption <- c('Hover over rows in the LOD image at top to see the individual curves below and, ',
                 'to the right, a plot of LOD score for each column at that genomic position.')
  append_caption(caption, file)

  append_html_jscode(file, 'scanoneData = ', scanone_json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iplotMScanone_noeff(scanoneData, chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}

# iplotMScanone_eff: multiple LOD curves + QTL effects
iplotMScanone_eff <-
function(scanoneOutput, effects,
         file, onefile=FALSE, openfile=TRUE,
         title="", caption, chartOpts=NULL, ...)
{
  scanone_json <- scanone2json(scanoneOutput, ...)
  effects_json <- effects2json(effects, ...)

  write_html_top(file, title=title)

  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_colorbrewer(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_panel('lodheatmap', file, onefile=onefile)
  link_panel('lodchart', file, onefile=onefile)
  link_panel('curvechart', file, onefile=onefile)
  link_chart('iplotMScanone_eff', file, onefile=onefile)

  append_html_middle(file, title, 'chart')
  
  if(missing(caption) || is.null(caption))
    caption <- c('Hover over LOD heat map to view individual curves below and ',
                'estimated QTL effects to the right.')
  append_caption(caption, file)

  append_html_jscode(file, 'scanoneData = ', scanone_json, ';')
  append_html_jscode(file, 'effectsData = ', effects_json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iplotMScanone_eff(scanoneData, effectsData, chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
