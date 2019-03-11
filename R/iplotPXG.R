## iplotPXG
## Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param cross Object of class `"cross"`, see
#'   [qtl::read.cross()].
#' @param marker Character string with marker name.
#' @param pheno.col Phenotype column in cross object.
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#' @param fillgenoArgs List of named arguments to pass to
#'   [qtl::fill.geno()], if needed.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details The function [qtl::fill.geno()] is used to
#' impute missing genotypes, with arguments passed as a list, for
#' example `fillgenoArgs=list(method="argmax", error.prob=0.002,
#' map.function="c-f")`.
#'
#' Individual IDs (viewable when hovering over a point) are taken from
#' the input `cross` object, using the [qtl::getid()]
#' function in R/qtl.
#'
#' By default, points are colored blue and pink according to whether
#' the marker genotype is observed or inferred, respectively.
#'
#' @keywords hplot
#' @seealso [idotplot()], [iplot()], [iplotScanone()],
#' [iplotMap()]
#'
#' @examples
#' library(qtl)
#' data(hyper)
#' marker <- sample(markernames(hyper), 1)
#' \donttest{
#' iplotPXG(hyper, marker)
#'
#' # different colors
#' iplotPXG(hyper, marker, chartOpts=list(pointcolor=c("black", "gray")))}
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

    pxg_data <- convert_pxg(qtl::pull.markers(cross, marker), pheno.col, fillgenoArgs=fillgenoArgs)

    # use phenotype name as y-axis label, unless ylab is already provided
    # same for title (with marker name)
    chartOpts <- add2chartOpts(chartOpts, ylab=getPhename(cross, pheno.col), xlab="Genotype",
                               title=marker, xcategories=seq(along=pxg_data$genonames[[1]]),
                               xcatlabels=pxg_data$genonames[[1]],
                               pointcolor=c("slateblue", "#ff851b")) # second color is orange

    pxg_data$geno <- as.numeric(pxg_data$geno)
    group <- pxg_data$geno < 0 + 1

    idotplot(abs(pxg_data$geno), pxg_data$pheno, pxg_data$indID, group,
             chartOpts=chartOpts, digits=digits)
}
