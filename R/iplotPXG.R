## iplotPXG
## Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param cross Object of class \code{"cross"}, see
#'   \code{\link[qtl]{read.cross}}.
#' @param marker Character string with marker name.
#' @param pheno.col Phenotype column in cross object.
#' @param file Optional character vector with file to contain the
#'   output.
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code.
#' @param openfile If TRUE, open the plot in the default web browser.
#' @param title Character string with title for plot.
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option. See details.
#' @param fillgenoArgs List of named arguments to pass to
#'   \code{\link[qtl]{fill.geno}}, if needed.
#' @param digits Number of digits in JSON; passed to \cite{\link[jsonlite]{toJSON}}.
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
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
#' @importFrom utils browseURL
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotMap}}
#'
#' @examples
#' data(hyper)
#' marker <- sample(markernames(hyper), 1)
#' \donttest{
#' # open iplotPXG in web browser
#' iplotPXG(hyper, marker, title="iplotPXG example")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotPXG(hyper, marker, title="iplotPXG example",
#'          openfile=FALSE)}
#'
#' @export
iplotPXG <-
function(cross, marker, pheno.col=1,
         file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart',
         caption, chartOpts=list(title=marker[1]),
         fillgenoArgs=NULL, digits=4, print=FALSE)
{
    if(class(cross)[2] != "cross")
        stop('"cross" should have class "cross".')

    if(length(marker) > 1) {
        marker <- marker[1]
        warning('marker should have length 1; using "', marker, '"')
    }

    if(missing(file)) file <- NULL

    if(missing(caption) || is.null(caption))
        caption <- c('Pink points correspond to individuals with imputed genotypes at this marker. ',
                     'Click on a point for a bit of gratuitous animation.')

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil"),
                      panels="dotchart", charts="iplotPXG", chartdivid=chartdivid,
                      caption=caption, print=print)

    json <- pxg2json(pull.markers(cross, marker), pheno.col, fillgenoArgs=fillgenoArgs, digits=digits)

    # use phenotype name as y-axis label, unless ylab is already provided
    chartOpts <- add2chartOpts(chartOpts, ylab=getPhename(cross, pheno.col))

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_data = '), json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotPXG(', chartdivid, '_data,', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}
