## iplotMap
## Karl W Broman

#' Interactive genetic map plot
#'
#' Creates an interactive graph of a genetic marker map.
#'
#' @param map Object of class \code{"map"}, a list with each component
#'   being a vector of marker positions.
#' @param shift If TRUE, shift each chromsome so that the initial marker
#'   is at position 0.
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
#' @param digits Number of digits in JSON; passed to \cite{\link[jsonlite]{toJSON}}.
#' @param print If TRUE, print the output, rather than writing it to a file,
#' for use within an R Markdown document.
#'
#' @return Character string with the name of the file created.
#'
#' @importFrom utils browseURL
#' @importFrom qtl pull.map
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotPXG}}
#'
#' @examples
#' data(hyper)
#' map <- pull.map(hyper)
#' iplotMap(map, shift=TRUE, title="iplotMap example")
#'
#' @export
iplotMap <-
function(map, shift=FALSE, file, onefile=FALSE, openfile=TRUE, title="",
         chartdivid='chart', caption, chartOpts=NULL, digits=4, print=FALSE)
{
    if("cross" %in% class(map)) map <- pull.map(map)

    if(missing(file)) file <- NULL

    if(missing(caption) || is.null(caption))
        caption <- 'Hover over marker positions to view the marker names.'

    file <- write_top(file, onefile, title, links=c("d3", "d3tip", "panelutil", "jquery"),
                      panels="mapchart", charts="iplotMap", chartdivid=chartdivid,
                      caption=caption, print=print)

    if(shift) map <- shiftmap(map)
    json <- map2json(map, digits=digits)

    # add chartdivid to chartOpts
    chartOpts <- add2chartOpts(chartOpts, chartdivid=chartdivid)

    append_html_jscode(file, paste0(chartdivid, '_data = '), json, ';')
    append_html_chartopts(file, chartOpts, chartdivid=chartdivid)
    append_html_jscode(file, paste0('iplotMap(', chartdivid, '_data,',
                                    chartdivid, '_chartOpts);'))

    add_searchbox(file, "markerinput", "marker", "Marker name")
    append_html_jscode(file, paste0('markersearch(', chartdivid, '_data.markernames,',
                                    chartdivid, '_chartOpts);'))

    append_html_bottom(file, print=print)

    if(openfile && !print) browseURL(file)

    invisible(file)
}

add_searchbox <-
function(file, formid="markerinput", inputid="marker", text="Marker name")
{

    cat('\n<div class="searchbox" id="', formid, '">\n',
        file=file, append=TRUE, sep='')
    cat('    <form name="', formid, '">\n',
        file=file, append=TRUE, sep='')
    cat('        <input id="', inputid, '" type="text" value="', text, '" name="', inputid, '"/>\n',
        file=file, append=TRUE, sep='')
    cat('        <input type="submit" id="submit" value="Submit" />\n',
        file=file, append=TRUE, sep='')
    cat('        <a id="current', inputid, '"></a>\n',
        file=file, append=TRUE, sep='')
    cat('    </form>\n</div>\n\n',
        file=file, append=TRUE, sep='')
}
