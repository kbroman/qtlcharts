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
#' @param file Optional character vector with file to contain the
#'   output
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=""})
#' @param fillgenoArgs List of named arguments to pass to
#'   \code{\link[qtl]{fill.geno}}, if needed.
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#' @param digits Number of digits in JSON; pass to
#'   \code{\link[jsonlite]{toJSON}}
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
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
#' # open iplotScanone (with CIs) in web browser
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
#'              title="iplotScanone example (CIs)")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
#'              title="iplotScanone example (CIs)",
#'              openfile=FALSE)}
#'
#' \donttest{
#' # open iplotScanone (with raw phe x gen)
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
#'              title="iplotScanone example (raw phe x gen)",
#'              pxgtype='raw')}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15),
#'              title="iplotScanone example (raw phe x gen)",
#'              pxgtype='raw', openfile=FALSE)}
#'
#' @export
iplotScanone <-
function(scanoneOutput, cross, lodcolumn=1, pheno.col=1, chr,
         pxgtype = c("ci", "raw"),
         file, onefile=FALSE, openfile=TRUE, title="", chartdivid='chart',
         caption, fillgenoArgs=NULL, chartOpts=NULL, digits=4, print=FALSE)
{
    if(missing(file)) file <- NULL

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

    if(missing(caption)) caption <- NULL

    if(missing(cross) || is.null(cross))
        return(iplotScanone_noeff(scanoneOutput=scanoneOutput, file=file, onefile=onefile,
                                  openfile=openfile, title=title, chartdivid=chartdivid,
                                  caption=caption,
                                  chartOpts=chartOpts, digits=digits, print=print))

    if(length(pheno.col) > 1) {
        pheno.col <- pheno.col[1]
        warning("pheno.col should have length 1; using first value")
    }

    if(class(cross)[2] != "cross")
        stop('"cross" should have class "cross".')

    if(pxgtype == "raw")
        return(iplotScanone_pxg(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                                file=file, onefile=onefile, openfile=openfile, title=title,
                                chartdivid=chartdivid, caption=caption, fillgenoArgs=fillgenoArgs,
                                chartOpts=chartOpts, digits=digits, print=print))

    else
        return(iplotScanone_ci(scanoneOutput=scanoneOutput, cross=cross, pheno.col=pheno.col,
                               file=file, onefile=onefile, openfile=openfile, title=title,
                               chartdivid=chartdivid, caption=caption, fillgenoArgs=fillgenoArgs,
                               chartOpts=chartOpts, digits=digits, print=print))

    invisible(file)
}


# iplotScanone: LOD curves with nothing else
iplotScanone_noeff <-
function(scanoneOutput, file, onefile=FALSE, openfile=TRUE, title="", chartdivid='chart',
         caption, chartOpts=NULL, digits=4, print=FALSE)
{
    if(missing(caption) || is.null(caption))
        caption <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                     'Click on a marker for a bit of gratuitous animation.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels="lodchart", charts="iplotScanone_noeff", chartdivid=chartdivid,
                      caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_data = '),
                       scanone2json(scanoneOutput, digits=digits), ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotScanone_noeff(', chartdivid, '_data, ',
                                    chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) utils::browseURL(file)

    invisible(file)
}


# iplotScanone_pxg: LOD curves with linked phe x gen plot
iplotScanone_pxg <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE,
         title="", chartdivid=chartdivid, caption, fillgenoArgs=NULL,
         chartOpts=NULL, digits=4, print=FALSE)
{
    scanone_json <- scanone2json(scanoneOutput, digits=digits)
    pxg_json <- pxg2json(cross, pheno.col, fillgenoArgs=fillgenoArgs, digits=digits)

    if(missing(caption) || is.null(caption))
        caption <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                     'Click on a marker to view the phenotype &times; genotype plot on the right. ',
                     'In the phenotype &times; genotype plot, the intervals indicate the mean &plusmn; 2 SE.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels=c("lodchart", "dotchart"), charts="iplotScanone_pxg",
                      chartdivid=chartdivid, caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_scanoneData = '), scanone_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_pxgData = '), pxg_json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotScanone_pxg(', chartdivid, '_scanoneData, ',
                                    chartdivid, '_pxgData, ', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) utils::browseURL(file)

    invisible(file)
}

# iplotScanone_ci: LOD curves with linked phe mean +/- 2 SE x gen plot
iplotScanone_ci <-
function(scanoneOutput, cross, pheno.col=1, file, onefile=FALSE, openfile=TRUE,
         title="", chartdivid='chart', caption, fillgenoArgs=NULL, chartOpts=NULL,
         digits=4, print=FALSE)
{
    scanone_json <- scanone2json(scanoneOutput, digits=digits)
    pxg_json <- pxg2json(cross, pheno.col, fillgenoArgs=fillgenoArgs, digits=digits)

    if(missing(caption) || is.null(caption))
        caption <- c('Hover over marker positions on the LOD curve to see the marker names. ',
                     'Click on a marker to view the phenotype &times; genotype plot on the right. ',
                     'In the phenotype &times; genotype plot, the intervals indicate the mean &plusmn; 2 SE.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels=c("lodchart", "cichart"), charts="iplotScanone_ci",
                      chartdivid=chartdivid, caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_scanoneData = '), scanone_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_pxgData = '), pxg_json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotScanone_ci(', chartdivid, '_scanoneData, ',
                                    chartdivid, '_pxgData, ', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) utils::browseURL(file)

    invisible(file)
}
