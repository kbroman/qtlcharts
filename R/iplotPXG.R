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
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#' @param fillgenoArgs List of named arguments to pass to
#'   \code{\link[qtl]{fill.geno}}, if needed.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
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
#' @keywords hplot
#' @seealso \code{\link{iplotScanone}}, \code{\link{iplotMap}}
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' marker <- sample(markernames(hyper), 1)
#' \donttest{
#' iplotPXG(hyper, marker)}
#'
#' @export
iplotPXG <-
function(cross, marker, pheno.col=1,
         chartOpts=NULL, fillgenoArgs=NULL, digits=5)
{
    if(class(cross)[2] != "cross")
        stop('"cross" should have class "cross".')

    if(length(marker) > 1) {
        marker <- marker[1]
        warning('marker should have length 1; using "', marker, '"')
    }

    # use phenotype name as y-axis label, unless ylab is already provided
    # same for title (with marker name)
    chartOpts <- add2chartOpts(chartOpts, ylab=getPhename(cross, pheno.col),
                               title=marker)

    x <- list(data=convert_pxg(qtl::pull.markers(cross, marker), pheno.col, fillgenoArgs=fillgenoArgs),
              chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    defaultAspect <- 1 # width/height
    browsersize <- getPlotSize(defaultAspect)

    htmlwidgets::createWidget("iplotPXG", x,
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
iplotPXG_output <- function(outputId, width="100%", height="530") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotPXG", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotPXG_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotPXG_output, env, quoted=TRUE)
}
