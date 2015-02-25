## iplotRF
## Karl W Broman

#' Interactive plot of recombination fractions
#'
#' Creates an interactive graph of estimated recombination fractions and LOD scores for all pairs of markers.
#'
#' @param cross Object of class \code{"cross"}, see
#'     \code{\link[qtl]{read.cross}}.
#' @param chr Optional vector indicating chromosomes to include. This
#'     should be a vector of character strings referring to chromosomes by
#'     name; numeric values are converted to strings.  Refer to
#'     chromosomes with a preceding \code{-} to have all chromosomes but
#'     those considered.  A logical (TRUE/FALSE) vector may also be used.
#' @param chartOpts A list of options for configuring the chart.  Each
#'     element must be named using the corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link[qtl]{est.rf}}, \code{\link[qtl]{plotRF}}
#'
#' @details The usual \code{height} and \code{width} options in
#' \code{chartOpts} are ignored in this plot. Instead, you may provide
#' \code{pixelPerCell} (number of pixels per cell in the heat map),
#' \code{chrGap} (gap in pixels between chromosomes in the heat map),
#' \code{cellHeight} (height in pixels of each cell in the
#' cross-tabulation), \code{cellWidth} (width in pixels of each cell
#' in the cross-tabulation), and \code{hbot} (height in pixels of the
#' lower panels showing cross-sections of the heat map)
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' hyper <- est.rf(hyper)
#' \donttest{
#' iplotRF(hyper)}
#'
#' @export
iplotRF <-
function(cross, chr, chartOpts=NULL)
{
    if(!missing(chr)) cross <- cross[chr,]

    rf <- data4iplotRF(cross)
    geno <- convert4crosstab(cross)

    htmlwidgets::createWidget("iplotRF", list(rfdata=rf, genodata=geno,
                                              chartOpts=chartOpts),
                              width=NULL, height=NULL,
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotRF_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotRF", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotRF_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotRF_output, env, quoted=TRUE)
}

# convert RF/LOD and genotypes for iplotRF
data4iplotRF <-
function(cross)
{
    if(!("rf" %in% names(cross))) {
        warning("Running est.rf.")
        cross <- qtl::est.rf(cross)
    }

    rf <- cross$rf
    diag(rf) <- NA
    mnames <- qtl::markernames(cross)
    dimnames(rf) <- NULL
    n.mar <- qtl::nmar(cross)
    names(n.mar) <- NULL
    chrnam <- qtl::chrnames(cross)

    map <- qtl::pull.map(cross, as.table=TRUE)
    chr <- as.character(map[,1])
    pos <- map[,2]

    list(rf=rf, nmar=n.mar, chrnames=chrnam,
         labels=mnames, chr=chr, pos=pos)
}
