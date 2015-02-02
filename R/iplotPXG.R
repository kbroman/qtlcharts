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
#'
#' @return None.
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
#' iplotPXG(hyper, marker, chartOpts=list(width=500))}
#'
#' @export
iplotPXG <-
function(cross, marker, pheno.col=1,
         chartOpts=NULL, fillgenoArgs=NULL)
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

    htmlwidgets::createWidget("iplotPXG", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              package="qtlcharts")
}

#' @export
iplotPXG_output <- function(outputId, width="100%", height="530") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotPXG", width, height, package="qtlcharts")
}
#' @export
iplotPXG_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotPXG_output, env, quoted=TRUE)
}
