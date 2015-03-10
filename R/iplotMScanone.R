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
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details If \code{cross} is provided, Haley-Knott regression is
#' used to estimate QTL effects at each pseudomarker.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}
#'
#' @examples
#' data(grav)
#' library(qtl)
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
#' # plot with qualitative labels on y-axis
#' iplotMScanone(out)}
#'
#' \donttest{
#' # plot with quantitative y-axis
#' iplotMScanone(out, times=times)}
#'
#' # estimate QTL effect for each time point at each genomic position
#' eff <- estQTLeffects(grav, phe=seq(1, nphe(grav), by=5), what="effects")
#'
#' \donttest{
#' # plot with QTL effects included (and with quantitative y-axis)
#' iplotMScanone(out, effects=eff, times=times,
#'               chartOpts=list(eff_ylab="QTL effect", eff_xlab="Time (hrs)"))}
#'
#' @export
iplotMScanone <-
function(scanoneOutput, cross, lodcolumn, pheno.col, times=NULL,
         effects, chr, chartOpts=NULL)
{
    if(!any(class(scanoneOutput) == "scanone"))
        stop('"scanoneOutput" should have class "scanone".')

    if(!missing(chr) && !is.null(chr)) {
        rn <- rownames(scanoneOutput)
        scanoneOutput <- subset(scanoneOutput, chr=chr)
        if(!missing(effects) && !is.null(effects)) effects <- effects[match(rownames(scanoneOutput), rn)]
        if(!missing(cross) && !is.null(cross)) cross <- subset(cross, chr=chr)
    }

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
    if(is.null(times)) times <- NULL

    if(missing(pheno.col) || is.null(pheno.col)) pheno.col <- seq(along=lodcolumn)

    if((missing(cross) || is.null(cross)) && (missing(effects) || is.null(effects))) { # no effects
        show_effects <- FALSE
        effects_list <- NULL
    }
    else {
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

        effects_list <- convert_effects(effects)
        show_effects <- TRUE
    }

    scanone_list <- convert_scanone(scanoneOutput)

    defaultAspect <- 1.5 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("iplotMScanone",
                              list(lod_data=scanone_list,
                                   eff_data=effects_list,
                                   times=times,
                                   show_effects=show_effects,
                                   chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=browsersize["width"],
                                  browser.defaultHeight=browsersize["height"],
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=1000/defaultAspect
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotMScanone_output <- function(outputId, width="100%", height="580") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotMScanone", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotMScanone_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotMScanone_output, env, quoted=TRUE)
}
