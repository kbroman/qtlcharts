## iplotScanone
## Karl W Broman

#' Interactive LOD curve
#'
#' Creates an interactive graph of a single-QTL genome scan, as
#' calculated by \code{\link[qtl]{scanone}}. If \code{cross} is
#' provided, the LOD curves are linked to a phenotype x genotype plot
#' for a marker: Click on a marker on the LOD curve and see the
#' corresponding phenotype x genotype plot.
#'
#' @param scanoneOutput Object of class \code{"scanone"}, as output
#'   from \code{\link[qtl]{scanone}}.
#' @param cross (Optional) Object of class \code{"cross"}, see
#'   \code{\link[qtl]{read.cross}}.
#' @param lodcolumn Numeric value indicating LOD score column to plot.
#' @param pheno.col (Optional) Phenotype column in cross object.
#' @param chr (Optional) Vector indicating the chromosomes
#'   for which LOD scores should be calculated. This should be a vector
#'   of character strings referring to chromosomes by name; numeric
#'   values are converted to strings. Refer to chromosomes with a
#'   preceding - to have all chromosomes but those considered. A logical
#'   (TRUE/FALSE) vector may also be used.
#' @param pxgtype If phenotype x genotype plot is to be shown, should
#'   it be with means \eqn{\pm}{+/-} 2 SE (\code{"ci"}), or raw
#'   phenotypes (\code{"raw"})?
#' @param fillgenoArgs List of named arguments to pass to
#'   \code{\link[qtl]{fill.geno}}, if needed.
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details If \code{cross} is provided, \code{\link[qtl]{fill.geno}}
#' is used to impute missing genotypes. In this case, arguments to
#' \code{\link[qtl]{fill.geno}} are passed as a list, for example
#' \code{fillgenoArgs=list(method="argmax", error.prob=0.002,
#' map.function="c-f")}.
#'
#' With \code{pxgtype="raw"}, individual IDs (viewable when hovering
#' over a point in the phenotype-by-genotype plot) are taken from the
#' input \code{cross} object, using the \code{\link[qtl]{getid}}
#' function in R/qtl.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotMScanone}}, \code{\link{iplotPXG}}, \code{\link{iplotMap}}
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' hyper <- calc.genoprob(hyper, step=1)
#' out <- scanone(hyper)
#' \donttest{
#' # iplotScanone with no effects
#' iplotScanone(out, chr=c(1, 4, 6, 7, 15))}
#'
#' \donttest{
#' # iplotScanone with CIs
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15))}
#'
#' \donttest{
#' # iplotScanone with raw phe x gen
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
#'              pxgtype='raw')}
#'
#' @export
iplotScanone <-
function(scanoneOutput, cross, lodcolumn=1, pheno.col=1, chr,
         pxgtype = c("ci", "raw"),
         fillgenoArgs=NULL, chartOpts=NULL)
{
    if(!any(class(scanoneOutput) == "scanone"))
        stop('"scanoneOutput" should have class "scanone".')

    if(!missing(chr) && !is.null(chr)) {
        scanoneOutput <- subset(scanoneOutput, chr=chr)
        if(!missing(cross) && !is.null(cross)) cross <- subset(cross, chr=chr)
    }

    pxgtype <- match.arg(pxgtype)

    if(length(lodcolumn) > 1) {
        lodcolumn <- lodcolumn[1]
        warning("lodcolumn should have length 1; using first value")
    }
    if(lodcolumn < 1 || lodcolumn > ncol(scanoneOutput)-2)
        stop('lodcolumn must be between 1 and ', ncol(scanoneOutput)-2)

    scanoneOutput <- scanoneOutput[,c(1,2,lodcolumn+2), drop=FALSE]
    colnames(scanoneOutput)[3] <- 'lod'
    scanone_list <- convert_scanone(scanoneOutput)

    if(missing(cross) || is.null(cross)) { # no effect plot
        pxgtype <- "none"
        pxg_list <- NULL
    } else { # include QTL effects
        if(length(pheno.col) > 1) {
            pheno.col <- pheno.col[1]
            warning("pheno.col should have length 1; using first value")
        }

        if(class(cross)[2] != "cross")
            stop('"cross" should have class "cross".')

        pxg_list <- convert_pxg(cross, pheno.col, fillgenoArgs=fillgenoArgs)
    }

    defaultAspect <- 2 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("iplotScanone",
                              list(scanone_data=scanone_list, pxg_data=pxg_list, pxg_type=pxgtype,
                                   chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize$width,
                                  browser.defaultHeight=browsersize$height,
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=1000/defaultAspect
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotScanone_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotScanone", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotScanone_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotScanone_output, env, quoted=TRUE)
}
