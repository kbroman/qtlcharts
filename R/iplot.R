## iplot
## Karl W Broman

#' Interactive scatterplot
#'
#' Creates an interactive scatterplot.
#'
#' @param x Numeric vector of x values
#' @param y Numeric vector of y values
#' @param group Optional vector of categories for coloring the points
#' @param indID Optional vector of character strings, shown with tool tips
#' @param file Optional character vector with file to contain the
#'   output.
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code.
#' @param openfile If TRUE, open the plot in the default web browser.
#' @param title Character string with title for plot.
#' @param chartdivid Character string for id of div to hold the chart
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=""})
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option. See details.
#' @param digits Number of digits in JSON; passed to \cite{\link[jsonlite]{toJSON}}.
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
#'
#' @return Character string with the name of the file created.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}, \code{\link{iplotCurves}}
#'
#' @examples
#' x <- rnorm(100)
#' grp <- sample(1:3, 100, replace=TRUE)
#' y <- x*grp + rnorm(100)
#' \donttest{
#' # open iplot in web browser
#' iplot(x, y, grp, title="iplot example")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplot(x, y, grp, title="iplot example",
#'       openfile=FALSE)}
#'
#' @export
iplot <-
function(x, y, group, indID,
         file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart',
         caption, chartOpts=NULL,
         digits=4, print=FALSE)
{
    if(length(x) != length(y))
        stop("length(x) != length(y)")
    if(missing(group) || is.null(group))
        group <- rep(1, length(x))
    else if(length(group) != length(x))
        stop("length(group) != length(x)")
    if(missing(indID) || is.null(indID))
        indID <- as.character(seq(along=x))
    else if(length(indID) != length(x))
        stop("length(indID) != length(x)")
    indID <- as.character(indID)

    if(missing(file)) file <- NULL

    if(missing(caption) || is.null(caption))
        caption <- 'Hover over a point to view tool tip with identifier.'

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "colorbrewer", "panelutil"),
                      panels="scatterplot", charts="iplot", chartdivid=chartdivid,
                      caption=caption, print=print)

    json <- jsonlite::toJSON(list(x=x, y=y, group=group, indID=indID), digits=digits)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_data = '), json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplot(', chartdivid, '_data,', chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) utils::browseURL(file)

    invisible(file)
}
