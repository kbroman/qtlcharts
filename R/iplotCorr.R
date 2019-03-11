## iplotCorr
## Karl W Broman

#' Image of correlation matrix with linked scatterplot
#'
#' Creates an interactive graph with an image of a
#' correlation matrix linked to underlying scatterplots.
#'
#' @param mat Data matrix (individuals x variables)
#' @param group Optional vector of groups of individuals (e.g., a genotype)
#' @param rows Selected rows of the correlation matrix to include in
#'   the image. Ignored if `corr` is provided.
#' @param cols Selected columns of the correlation matrix to include
#'   in the image. Ignored if `corr` is provided.
#' @param reorder If TRUE, reorder the variables by
#'   clustering. Ignored if `corr` is provided as a subset of the
#'   overall correlation matrix
#' @param corr Correlation matrix (optional).
#' @param scatterplots If `FALSE`, don't have the heat map be
#'   linked to scatterplots.
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#' @param digits Round data to this number of significant digits
#'     before passing to the chart function. (Use NULL to not round.)
#'
#' @return An object of class `htmlwidget` that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents, and within
#' Shiny output bindings.
#'
#' @details `corr` may be provided as a subset of the overall
#' correlation matrix for the columns of `mat`. In this case, the
#' `reorder`, `rows` and `cols` arguments are ignored. The row and
#' column names of `corr` must match the names of some subset of
#' columns of `mat`.
#'
#' Individual IDs are taken from `rownames(mat)`; they must match
#' `names(group)`.
#'
#' @keywords hplot
#' @seealso [iheatmap()], [scat2scat()], [iplotCurves()]
#'
#' @examples
#' data(geneExpr)
#' \donttest{
#' iplotCorr(geneExpr$expr, geneExpr$genotype, reorder=TRUE,
#'           chartOpts=list(cortitle="Correlation matrix",
#'                          scattitle="Scatterplot"))}
#'
#' # use Spearman's correlation
#' corr <- cor(geneExpr$expr, method="spearman", use="pairwise.complete.obs")
#' # order by hierarchical clustering
#' o <- hclust(as.dist(1-corr))$order
#' \donttest{
#' iplotCorr(geneExpr$expr[,o], geneExpr$genotype, corr=corr[o,o],
#'           chartOpts=list(cortitle="Spearman correlation",
#'                          scattitle="Scatterplot"))}
#' @export
iplotCorr <-
function(mat, group=NULL, rows=NULL, cols=NULL, reorder=FALSE, corr=NULL,
         scatterplots=TRUE, chartOpts=NULL, digits=5)
{
    if(is.null(group)) group <- rep(1, nrow(mat))
    if(is.data.frame(mat)) mat <- as.matrix(mat)
    stopifnot(length(group) == nrow(mat))
    group <- group2numeric(group)

    if(!is.null(corr)) {
        if(!is.null(rows) || !is.null(cols)) warning("rows and cols ignored when corr provided.")
        if(!missing(reorder)) warning("reorder ignored when corr provided")
        reorder <- FALSE

        cnmat <- colnames(mat)
        if(ncol(mat) != nrow(corr) || ncol(mat) != nrow(corr)) { # correlation matrix is a subset
            rows <- selectMatrixColumns(mat, rownames(corr))
            cols <- selectMatrixColumns(mat, colnames(corr))
        }
        else {
            if((!is.null(rownames(corr)) && any(rownames(corr) != cnmat)) ||
               (!is.null(colnames(corr)) && any(colnames(corr) != cnmat)))
                warning("Possible misalignment of mat and corr")
            rows <- cols <- 1:ncol(mat)
        }

        corr_was_presubset <- TRUE
    }
    else {
        corr <- stats::cor(mat, use="pairwise.complete.obs")
        if(is.null(rows)) rows <- (1:ncol(mat))
        else rows <- selectMatrixColumns(mat, rows)
        if(is.null(cols)) cols <- (1:ncol(mat))
        else cols <- selectMatrixColumns(mat, cols)
        corr_was_presubset <- FALSE
    }

    data_list <- convert4iplotcorr(mat, group, rows, cols, reorder, corr, corr_was_presubset,
                                   scatterplots)

    defaultAspect <- 2 # width/height
    browsersize <- getPlotSize(defaultAspect)

    x <- list(data=data_list, chartOpts=chartOpts)
    if(!is.null(digits))
        attr(x, "TOJSON_ARGS") <- list(digits=digits)

    htmlwidgets::createWidget("iplotCorr", x,
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
iplotCorr_output <- function(outputId, width="100%", height="1000") {
    htmlwidgets::shinyWidgetOutput(outputId, "iplotCorr", width, height, package="qtlcharts")
}

#' @rdname qtlcharts-shiny
#' @export
iplotCorr_render <- function(expr, env=parent.frame(), quoted=FALSE) {
    if(!quoted) { expr <- substitute(expr) } # force quoted
    htmlwidgets::shinyRenderWidget(expr, iplotCorr_output, env, quoted=TRUE)
}
