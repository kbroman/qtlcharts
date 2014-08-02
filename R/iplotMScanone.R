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
#' @param times (Optional) Vector (length equal to the number of LOD
#'   score columns) with quantitative values to which the different LOD
#'   score columns correspond (times of measurements, or something like
#'   age or dose).  These need to be ordered and equally-spaced. If
#'   omitted, the names of the columns in \code{scanoneOutput} are used
#'   and treated as qualitative.
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
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#' @param digits Number of digits in JSON; passed to
#'   \code{\link[jsonlite]{toJSON}}
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
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
#'
#' # we're going to subset the phenotypes
#' phecol <- seq(1, nphe(grav), by=5)
#'
#' # the times were saved as an attributed
#' times <- attr(grav, "time")[phecol]
#'
#' # genome scan
#' out <- scanone(grav, phe=phecol, method="hk")
#'
#' \donttest{
#' # plot with qualitative labels on y-axis (in web browser)
#' iplotMScanone(out, title="iplotMScanone example, no effects")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotMScanone(out, title="iplotMScanone example, no effects",
#'               openfile=FALSE)}
#'
#' \donttest{
#' # plot with quantitative y-axis
#' iplotMScanone(out, times=times, title="iplotMScanone example, no effects")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotMScanone(out, times=times, title="iplotMScanone example, no effects",
#'               openfile=FALSE)}
#'
#' # estimate QTL effect for each time point at each genomic position
#' eff <- estQTLeffects(grav, phe=seq(1, nphe(grav), by=5), what="effects")
#'
#' \donttest{
#' # plot with QTL effects included (and with quantitative y-axis)
#' iplotMScanone(out, effects=eff, times=times,
#'               title="iplotMScanone example, with effects",
#'               chartOpts=list(eff_ylab="QTL effect", eff_xlab="Time (hrs)"))}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotMScanone(out, effects=eff, times=times,
#'               title="iplotMScanone example, with effects",
#'               chartOpts=list(eff_ylab="QTL effect", eff_xlab="Time (hrs)"),
#'               openfile=FALSE)}
#'
#' @export
iplotMScanone <-
function(scanoneOutput, cross, lodcolumn, pheno.col, times=NULL,
         effects, chr,
         file, onefile=FALSE, openfile=TRUE, title="", chartdivid='chart',
         caption, chartOpts=NULL, digits=4, print=FALSE)
{
    if(missing(file)) file <- NULL

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

    # check times
    if(!is.null(times)) {
        if(!is_equally_spaced(times)) {
            warning("times is not equally spaced; ignored.")
            times <- NULL
        }
        else if(length(times) != ncol(scanoneOutput)-2) {
            warning("length(times) != no. LOD columns; times will be ignored")
            times <- NULL
        }
        else {
            names(times) <- NULL # make sure it's plain
        }
    }
    if(is.null(times)) times <- NA # this will get turned into null on the other end

    if(missing(pheno.col) || is.null(pheno.col)) pheno.col <- seq(along=lodcolumn)
    if((missing(cross) || is.null(cross)) && (missing(effects) || is.null(effects)))
        return(iplotMScanone_noeff(scanoneOutput, times=times,
                                   file=file, onefile=onefile, openfile=openfile, title=title,
                                   chartdivid=chartdivid,
                                   caption=caption, chartOpts=chartOpts, digits=digits, print=print))

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

    iplotMScanone_eff(scanoneOutput, effects, times=times,
                      file=file, onefile=onefile, openfile=openfile, title=title,
                      chartdivid=chartdivid,
                      caption=caption, chartOpts=chartOpts, digits=digits, print=print)
}


# iplotMScanone_noeff: multiple LOD curves; no QTL effects
iplotMScanone_noeff <-
function(scanoneOutput, times=NULL,
         file, onefile=FALSE, openfile=TRUE,
         title="", chartdivid='chart', caption, chartOpts=NULL, digits=4, print=FALSE)
{
    scanone_json <- scanone2json(scanoneOutput, digits=digits)

    if(missing(caption) || is.null(caption))
        caption <- c('Hover over rows in the LOD image at top to see the individual curves below and, ',
                     'to the right, a plot of LOD score for each column at that genomic position.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels=c("lodheatmap", "lodchart", "curvechart"),
                      charts="iplotMScanone_noeff", chartdivid=chartdivid,
                      caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_scanoneData = '), scanone_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_times = '), jsonlite::toJSON(times, na="null", auto_unbox=TRUE), ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotMScanone_noeff(', chartdivid, '_scanoneData, ',
                                    chartdivid, '_times, ', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}

# iplotMScanone_eff: multiple LOD curves + QTL effects
iplotMScanone_eff <-
function(scanoneOutput, effects, times=NULL,
         file, onefile=FALSE, openfile=TRUE,
         title="", chartdivid=chartdivid,
         caption, chartOpts=NULL, digits=4, print=FALSE)
{
    scanone_json <- scanone2json(scanoneOutput, digits=digits)
    effects_json <- effects2json(effects, digits=digits)

    if(missing(caption) || is.null(caption))
        caption <- c('Hover over LOD heat map to view individual curves below and ',
                     'estimated QTL effects to the right.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "colorbrewer", "panelutil"),
                      panels=c("lodheatmap", "lodchart", "curvechart"),
                      charts="iplotMScanone_eff", chartdivid=chartdivid,
                      caption=caption, print=print)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_scanoneData = '), scanone_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_effectsData = '), effects_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_times = '), jsonlite::toJSON(times, na="null", auto_unbox=TRUE), ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotMScanone_eff(', chartdivid, '_scanoneData, ',
                                    chartdivid, '_effectsData, ',
                                    chartdivid, '_times, ',
                                    chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}
