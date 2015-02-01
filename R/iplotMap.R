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
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option. See details.
#'
#' @return None.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotPXG}}
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' map <- pull.map(hyper)
#' \donttest{
#' iplotMap(map, shift=TRUE)}
#'
#' @export
iplotMap <-
function(map, shift=FALSE, chartOpts=NULL)
{
    if("cross" %in% class(map)) map <- qtl::pull.map(map)

    if(shift) map <- qtl::shiftmap(map)
    map_list <- convert_map(map)
    x <- list(data=map_list, chartOpts=chartOpts)

    htmlwidgets::createWidget("iplotMap", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

# convert map to special list
convert_map <-
function(map) {
    chrnames <- names(map)
    # force use of hash with single numeric values
    map <- lapply(map, function(a) lapply(a, jsonlite::unbox))

    mnames <- unlist(lapply(map, names))
    names(mnames) <- NULL

    list(chr=chrnames, map=map, markernames=mnames)
}

add_searchbox <-
function(file, formid="markerinput", inputid="marker", text="Marker name")
{

    cat('\n<div class="searchbox" id="', formid, '">\n',
        file=file, append=TRUE, sep='')
    cat('<form name="', formid, '">\n',
        file=file, append=TRUE, sep='')
    cat('<input id="', inputid, '" type="text" value="', text, '" name="', inputid, '"/>\n',
        file=file, append=TRUE, sep='')
    cat('<input type="submit" id="submit" value="Submit" />\n',
        file=file, append=TRUE, sep='')
    cat('<a id="current', inputid, '"></a>\n',
        file=file, append=TRUE, sep='')
    cat('</form>\n</div>\n\n',
        file=file, append=TRUE, sep='')
}
