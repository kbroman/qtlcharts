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
#' @param file Optional character vector with file to contain the
#'   output.
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code.
#' @param openfile If TRUE, open the plot in the default web browser.
#' @param title Character string with title for plot.
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'     combined to one string with \code{\link[base]{paste}}, with
#'     \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart.  Each
#'     element must be named using the corresponding option. See details.
#' @param digits Number of digits in JSON; passed to \cite{\link[jsonlite]{toJSON}}.
#' @param print If TRUE, print the output, rather than writing it to a file,
#'     for use within an R Markdown document.
#'
#' @return Character string with the name of the file created.
#'
#' @importFrom utils browseURL
#' @importFrom qtl pull.map
#'
#' @keywords hplot
#' @seealso \code{\link[qtl]{est.rf}}, \code{\link[qtl]{plotRF}}
#'
#' @examples
#' data(hyper)
#' hyper <- est.rf(hyper)
#' iplotRF(hyper)
#'
#' @export
iplotRF <-
function(cross, chr, file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart', caption, chartOpts=NULL, digits=4, print=FALSE)
{
    if(!missing(chr)) cross <- cross[chr,]

    if(missing(file)) file <- NULL

    if(missing(caption) || is.null(caption))
        caption <- c('Click on heatmap in top-left to view the corresponding two-locus ',
                     'genotype table to the right and LOD scores for selected markers, ',
                     'below. In subsequent cross-tabulation on right, hover over column ',
                     'and row headings to view conditional distributions. In panels below, ',
                     'hover over points to view marker names and click to refresh cross-tab ',
                     'and lower panels and selected marker.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels=c("chrheatmap", "crosstab", "lodchart"), charts="iplotRF", chartdivid=chartdivid,
                      caption=caption, print=print)

    rf_json <- data4iplotRF(cross)
    geno_json <- convert4crosstab(cross)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_rfdata = '), rf_json, ';')
    append_html_jscode(file, paste0(chartdivid, '_geno = '), geno_json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotRF(', chartdivid, '_rfdata,',
                                    chartdivid, '_geno,',
                                    chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}

# convert RF/LOD and genotypes for iplotRF
data4iplotRF <-
function(cross)
{
    if(!("rf" %in% names(cross))) {
        warning("Running est.rf.")
        cross <- est.rf(cross)
    }

    rf <- cross$rf
    diag(rf) <- NA
    mnames <- markernames(cross)
    dimnames(rf) <- NULL
    n.mar <- nmar(cross)
    names(n.mar) <- NULL
    chrnam <- chrnames(cross)

    map <- pull.map(cross, as.table=TRUE)
    chr <- as.character(map[,1])
    pos <- map[,2]

    jsonlite::toJSON(list(rf=rf, nmar=n.mar, chrnames=chrnam,
                          labels=mnames, chr=chr, pos=pos),
                     na="null")
}
