## iplotRF
## Karl W Broman

#' Interactive plot of recombination fractions
#'
#' Creates an interactive graph of estimated recombination fractions and LOD scores for all pairs of markers.
#'
#' @param cross Object of class `"cross"`, see
#'     [qtl::read.cross()].
#' @param chr Optional vector indicating chromosomes to include. This
#'     should be a vector of character strings referring to chromosomes by
#'     name; numeric values are converted to strings.  Refer to
#'     chromosomes with a preceding `-` to have all chromosomes but
#'     those considered.  A logical (TRUE/FALSE) vector may also be used.
#' @param chartOpts A list of options for configuring the chart.  Each
#'     element must be named using the corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso [qtl::est.rf()], [qtl::plotRF()]
#'
#' @details The usual `height` and `width` options in
#' `chartOpts` are ignored in this plot. Instead, you may provide
#' `pixelPerCell` (number of pixels per cell in the heat map),
#' `chrGap` (gap in pixels between chromosomes in the heat map),
#' `cellHeight` (height in pixels of each cell in the
#' cross-tabulation), `cellWidth` (width in pixels of each cell
#' in the cross-tabulation), and `hbot` (height in pixels of the
#' lower panels showing cross-sections of the heat map)
#'
#' @examples
#' library(qtl)
#' data(fake.f2)
#' \dontshow{fake.f2 <- fake.f2[c(1,5,13),]}
#' fake.f2 <- est.rf(fake.f2)
#' \donttest{
#' iplotRF(fake.f2)}
#'
#' @export
iplotRF <-
function(cross, chr=NULL, chartOpts=NULL, digits=5)
{
    if(!is.null(chr)) cross <- cross[chr,]

    rf <- data4iplotRF(cross)
    geno <- convert4crosstab(cross)

    defaultAspect <- 1 # width/height
    browsersize <- getPlotSize(defaultAspect)

    x <- list(rfdata=rf, genodata=geno, chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("iplotRF", x,
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

    list(rf=rf, nmar=n.mar, chrname=chrnam,
         marker=mnames, chr=chr, pos=pos)
}
