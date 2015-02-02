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
#' @param chr (Optional) Optional vector indicating the chromosomes
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
#' @return Character string with the name of the file created.
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

    if(missing(cross) || is.null(cross))
        return(iplotScanone_noeff(scanoneOutput=scanoneOutput,
                                  chartOpts=chartOpts))

    if(length(pheno.col) > 1) {
        pheno.col <- pheno.col[1]
        warning("pheno.col should have length 1; using first value")
    }

    if(class(cross)[2] != "cross")
        stop('"cross" should have class "cross".')

    if(pxgtype == "raw")
        return(iplotScanone_pxg(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                                fillgenoArgs=fillgenoArgs, chartOpts=chartOpts))

    else
        return(iplotScanone_ci(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                               fillgenoArgs=fillgenoArgs, chartOpts=chartOpts))

}


# iplotScanone: LOD curves with nothing else
iplotScanone_noeff <-
function(scanoneOutput, chartOpts=NULL)
{
    scanone_list <- convert_scanone(scanoneOutput)
    htmlwidgets::createWidget("iplotScanone_noeff",
                              list(scanone=scanone_list, chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

# iplotScanone_pxg: LOD curves with linked phe x gen plot
iplotScanone_pxg <-
function(scanoneOutput, cross, pheno.col=1, fillgenoArgs=NULL,
         chartOpts=NULL)
{
    scanone_list <- convert_scanone(scanoneOutput)
    pxg_list <- convert_pxg(cross, pheno.col, fillgenoArgs=fillgenoArgs)

    htmlwidgets::createWidget("iplotScanone_pxg",
                              list(scanone=scanone_list, pxg=pxg_list, chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

# iplotScanone_ci: LOD curves with linked phe mean +/- 2 SE x gen plot
iplotScanone_ci <-
function(scanoneOutput, cross, pheno.col=1, fillgenoArgs=NULL, chartOpts=NULL)
{
    scanone_list <- convert_scanone(scanoneOutput)
    pxg_list <- convert_pxg(cross, pheno.col, fillgenoArgs=fillgenoArgs)

    htmlwidgets::createWidget("iplotScanone_ci",
                              list(scanone=scanone_list, pxg=pxg_list, chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}
