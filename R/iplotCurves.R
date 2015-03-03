## iplotCurves.R
## Karl W Broman

#' Plot of a bunch of curves, linked to points in scatterplots
#'
#' Creates an interactive graph with a panel having a number of curves
#' (say, a phenotype measured over time) linked to one or two (or no) scatter plots
#' (say, of the first vs middle and middle vs last times).
#'
#' @param curveMatrix Matrix (dim n_ind x n_times) with outcomes
#' @param times Vector (length n_times) with time points for the
#'   columns of curveMatrix
#' @param scatter1 Matrix (dim n_ind x 2) with data for the first
#'   scatterplot
#' @param scatter2 Matrix (dim n_ind x 2) with data for the second
#'   scatterplot
#' @param group Optional vector of groups of individuals (e.g., a genotype)
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplotCorr}}
#'
#' @examples
#' # random growth curves, based on some data
#' times <- 1:16
#' n <- 100
#' start <- rnorm(n, 5.2, 0.8)
#' slope1to5 <- rnorm(n, 2.6, 0.5)
#' slope5to16 <- rnorm(n, 0.24 + 0.09*slope1to5, 0.195)
#' y <- matrix(ncol=16, nrow=n)
#' y[,1] <- start
#' for(j in 2:5)
#'     y[,j] <- y[,j-1] + slope1to5
#' for(j in 6:16)
#'     y[,j] <- y[,j-1] + slope5to16
#' y <- y + rnorm(prod(dim(y)), 0, 0.35)
#'
#' \donttest{
#' iplotCurves(y, times, y[,c(1,5)], y[,c(5,16)],
#'             chartOpts=list(curves_xlab="Time", curves_ylab="Size",
#'                            scat1_xlab="Size at T=1", scat1_ylab="Size at T=5",
#'                            scat2_xlab="Size at T=5", scat2_ylab="Size at T=16"))}
#'
#' @export
iplotCurves <-
function(curveMatrix, times, scatter1=NULL, scatter2=NULL, group=NULL,
         chartOpts=NULL)
{
    n.ind <- nrow(curveMatrix)
    n.times <- ncol(curveMatrix)
    if(missing(times) || is.null(times)) times <- 1:ncol(curveMatrix)
    if(length(times) != n.times)
        stop("length(times) != ncol(curveMatrix)")
    if(!is.null(scatter1) && nrow(scatter1) != n.ind)
        stop("nrow(scatter1) != nrow(curveMatrix)")
    if(!is.null(scatter2) && nrow(scatter2) != n.ind)
        stop("nrow(scatter2) != nrow(curveMatrix)")
    if(is.null(scatter1) && !is.null(scatter2)) {
        scatter1 <- scatter2
        scatter2 <- NULL
    }
    if(missing(group) || is.null(group)) group <- rep(1, n.ind)
    stopifnot(length(group) == n.ind)
    group <- group2numeric(group)
    indID <- rownames(curveMatrix)

    if(is.data.frame(curveMatrix)) curveMatrix <- as.matrix(curveMatrix)
    if(is.data.frame(scatter1)) scatter1 <- as.matrix(scatter1)
    if(is.data.frame(scatter2)) scatter2 <- as.matrix(scatter2)
    dimnames(curveMatrix) <- dimnames(scatter1) <- dimnames(scatter2) <- names(group) <- names(times) <- NULL


    data_list <- list(curve_data=convert_curves(times, curveMatrix, group, indID),
                      scatter1_data=convert_scat(scatter1, group, indID),
                      scatter2_data=convert_scat(scatter2, group, indID))

    htmlwidgets::createWidget("iplotCurves", list(data=data_list, chartOpts=chartOpts),
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=1000,
                                  browser.defaultHeight=800,
                                  knitr.defaultWidth=1000,
                                  knitr.defaultHeight=800,
                              ),
                              package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotCurves_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotCurves", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotCurves_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotCurves_output, env, quoted=TRUE)
}


convert_curves <-
function(times, curvedata, group, indID)
{
    list(x=times, data=curvedata, group=group, indID=indID)
}

convert_scat <-
function(scatdata, group, indID)
{
    if(is.null(scatdata)) return(NULL)

    list(data=scatdata, group=group, indID=indID)
}
