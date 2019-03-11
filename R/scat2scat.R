## scat2scat
## Karl W Broman

#' Scatterplot driving another scatterplot
#'
#' A pair of linked scatterplots, where each point the first
#' scatterplot corresponds to a scatter of points in the second
#' scatterplot. The first scatterplot corresponds to a pair of summary
#' measures for a larger dataset.
#'
#' @param scat1data Matrix with two columns; rownames are used as
#' identifiers. Can have an optional third column with categories for
#' coloring points in the first scatterplot (to be used if
#' `group` is not provided).
#' @param scat2data List of matrices each with at least two columns,
#' to be shown in the second scatterplot. The components of the list
#' correspond to the rows in `scat1dat`. An option third column
#' can contain categories. Row names identify individual points.
#' @param group Categories for coloring points in the first
#' scatterplot; length should be the number of rows in
#' `scat1data`.
#' @param chartOpts A list of options for configuring the chart.  Each
#'   element must be named using the corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @keywords hplot
#' @seealso [iplotCorr()]
#'
#' @examples
#' # simulate some data
#' p <- 500
#' n <- 300
#' SD <- runif(p, 1, 5)
#' r <- runif(p, -1, 1)
#' scat2 <- vector("list", p)
#' for(i in 1:p)
#'    scat2[[i]] <- matrix(rnorm(2*n), ncol=2) %*% chol(SD[i]^2*matrix(c(1, r[i], r[i], 1), ncol=2))
#' scat1 <- cbind(SD=SD, r=r)
#' # plot it
#' scat2scat(scat1, scat2)
#'
#' @importFrom stats setNames
#' @export
scat2scat <-
function(scat1data, scat2data, group=NULL, chartOpts=NULL, digits=5)
{
    stopifnot(ncol(scat1data) == 2 || ncol(scat1data)==3)
    stopifnot(nrow(scat1data) == length(scat2data))

    if(is.null(group) && ncol(scat1data)==3)
        group <- scat1data[,3]

    if(!is.null(group))
        stopifnot(nrow(scat1data) == length(group))

    # if there are names, check that they match
    nam1 <- rownames(scat1data)
    nam2 <- names(scat2data)
    if(!is.null(nam1) && !is.null(nam2) && any(nam1 != nam2)) {
        # try to reorder
        if(all(sort(nam1) == sort(nam2)))
            scat2data <- scat2data[match(nam1, nam2)]
        else stop("rownames(scat1data) != names(scat2data)")
    }

    # xlab and ylab
    cn <- colnames(scat1data)
    if(!is.null(cn))
        chartOpts <- add2chartOpts(chartOpts, xlab1=cn[1], ylab1=cn[2])
    # xlab and ylab for 2nd panel (from 2nd data set)
    xlab2 <- vapply(scat2data, function(a) { cn <- colnames(a); ifelse(is.null(cn), "", cn[1]) }, "")
    ylab2 <- vapply(scat2data, function(a) { cn <- colnames(a); ifelse(is.null(cn), "", cn[2]) }, "")
    chartOpts <- add2chartOpts(chartOpts, xlab2=xlab2, ylab2=ylab2)

    # reorganize data
    scat1data <- list(x = setNames(scat1data[,1], NULL),
                      y = setNames(scat1data[,2], NULL),
                      indID = get_indID(nrow(scat1data), rownames(scat1data)),
                      group=group2numeric(group))

    scat2data <- lapply(scat2data, function(a) {
        z <- list(x=setNames(a[,1], NULL),
                  y=setNames(a[,2], NULL),
                  indID=get_indID(nrow(a), rownames(a)))
        if(ncol(a)==3) z$group <- group2numeric(a[,3])
        z})

    # drop names to ensure it's an array rather than associative array
    names(scat2data) <- NULL

    defaultAspect <- 2 # width/height
    browsersize <- getPlotSize(defaultAspect)

    x <- list(scat1data=scat1data, scat2data=scat2data, chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("scat2scat", x,
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
scat2scat_output <- function(outputId, width="100%", height="530") {
    htmlwidgets::shinyWidgetOutput(outputId, "scat2scat", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
scat2scat_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, scat2scat_output, env, quoted=TRUE)
}
