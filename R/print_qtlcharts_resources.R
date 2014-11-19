## print_qtlcharts_resources.R
## Karl Broman

#' Print javascript resources for qtlcharts
#'
#' Print javascript resources, for use with R/qtlcharts within an R
#' Markdown document
#'
#' @param main Vector of character strings with the main resources to use
#'     If missing or \code{NULL}, the default is \code{c("d3", "d3tip",
#'     "colorbrewer", "panelutil")}.
#' @param panels Vector of character strings with the names of panel function
#'     to include. If missing or \code{NULL}, all panel functions are
#'     included.
#' @param charts Vector of character strings with the names of charts
#'     to include. If missing or \code{NULL}, all chart functions are
#'     included.
#' @param onefile If \code{TRUE}, print the source for the selected
#'     resources; if \code{FALSE}, just print links to the resources.
#'
#' @return None.
#'
#' @details If \code{onefile=FALSE}, the links to the selected
#'     resources are printed.
#'
#'     If \code{onefile=TRUE}, the javascript code for all selected
#'     resources are simply read into R with \code{\link[base]{readLines}}
#'     and then printed with \code{\link[base]{cat}}.
#'
#'     This is to be included in a knitr code chunk (with
#'     \code{results="asis"}) in an R Markdown document, for use by
#'     later calls to the interactive plots, each with
#'     \code{print=TRUE}.
#'
#' @keywords utilities
#'
#' @examples
#' \dontrun{print_qtlcharts_resources(panels=c("curvechart", "heatmap"), charts="iheatmap")}
#'
#' @export
print_qtlcharts_resources <-
function(main, panels, charts, onefile=TRUE)
{
    if(missing(main) || is.null(main)) {
        main <- c("d3", "d3tip", "colorbrewer", "panelutil", "jquery")
    }
    if(missing(panels) || is.null(panels)) {
        paneldir <- system.file("panels", package="qtlcharts")
        panels <- list.files(paneldir)
        g <- grep("\\.", panels) # throw out names with a dot
        if(length(g) > 0) panels <- panels[-g]
    }
    if(missing(charts) || is.null(charts)) {
        chartdir <- system.file("charts", package="qtlcharts")
        charts <- gsub(".js$", "", list.files(chartdir, pattern=".js$"))
    }

    if("d3" %in% main) link_d3(file='', onefile=onefile, print=TRUE)
    if("d3tip" %in% main) link_d3tip(file='', onefile=onefile, print=TRUE)
    if("colorbrewer" %in% main) link_colorbrewer(file='', onefile=onefile, print=TRUE)
    if("panelutil" %in% main) link_panelutil(file='', onefile=onefile, print=TRUE)
    if("jquery" %in% main) link_jquery(file='', onefile=onefile, print=TRUE)

    for(panel in panels)
        link_panel(panel, file='', onefile=onefile, print=TRUE)
    for(chart in charts)
        link_chart(chart, file='', onefile=onefile, print=TRUE)
}
