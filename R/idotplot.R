## iplotPXG
## Karl W Broman

#' Interactive phenotype x genotype plot
#'
#' Creates an interactive graph of phenotypes vs genotypes at a marker.
#'
#' @param group Vector of groups of individuals (e.g., a genotype)
#' @param y Numeric vector (e.g., a phenotype)
#' @param indID Optional vector of character strings, shown with tool tips
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso \code{\link{iplot}} \code{\link{iplotPXG}}
#'
#' @examples
#' n <- 100
#' g <- sample(LETTERS[1:3], n, replace=TRUE)
#' y <- rnorm(n, match(g, LETTERS[1:3])*10, 5)
#' \donttest{
#' idotplot(g, y)}
#'
#' @export
idotplot <-
function(group, y, indID, chartOpts=NULL)
{
    stopifnot(length(group) == length(y))
    if(missing(indID) || is.null(indID))
        indID <- seq(along=group)
    stopifnot(length(indID) == length(group))
    group_levels <- sort(unique(group))
    group <- group2numeric(group)

    chartOpts <- add2chartOpts(chartOpts, ylab="y", title="", xlab="group")

    # a bit of contortion with the data, to reuse iplotPXG
    x <- list(data=list(geno=matrix(group, nrow=1),
                        pheno=y,
                        chrByMarkers=list(group="un"),
                        indID=indID,
                        chrtype=list(un="A"),
                        genonames=list(A=group_levels)),
              chartOpts=chartOpts)

    htmlwidgets::createWidget("iplotPXG", x,
                              width=chartOpts$width,
                              height=chartOpts$height,
                              sizingPolicy=htmlwidgets::sizingPolicy(
                                  browser.defaultWidth=800,
                                  browser.defaultHeight=800,
                                  knitr.defaultWidth=600,
                                  knitr.defaultHeight=600),
                              package="qtlcharts")
}
