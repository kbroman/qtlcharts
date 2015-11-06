## convert4iplotcorr
## Karl W Broman

# Convert data to a list for iplotCorr vis
#
# @param dat Data matrix (individuals x variables)
# @param group Optional vector of groups of individuals (e.g., a genotype)
# @param rows Rows of correlation matrix to keep in image
# @param cols Columns of correlation matrix to keep in image
# @param reorder If TRUE, reorder the variables by clustering
# @param corr Correlation matrix
# @param corr_was_presubset: If TRUE, no need to subset with selected rows and columns
# @param scatterplots If FALSE, we won't be showing the scatterplots
#   so we don't need to include all of the data.
#
# @return Character string with the input data in JSON format
#
# @keywords interface
# @seealso \code{\link{iplotCorr}}
#
# @examples
# data(geneExpr)
# geneExpr_as_list <- convert4iplotcorr(geneExpr$expr, geneExpr$genotype,
#                                       rows=1:ncol(geneExpr$expr), cols=1:ncol(geneExpr$expr),
#                                       corr=cor(geneExpr$expr, use="pair"))
convert4iplotcorr <-
    function(dat, group, rows, cols, reorder=FALSE, corr, corr_was_presubset=FALSE,
             scatterplots=TRUE)
{
    indID <- rownames(dat)
    if(is.null(indID)) indID <- 1:nrow(dat)
    indID <- as.character(indID)

    variables <- colnames(dat)
    if(is.null(variables)) variable <- paste0("var", 1:ncol(dat))

    if(missing(group) || is.null(group)) group <- rep(1, nrow(dat))

    if(nrow(dat) != length(group))
        stop("nrow(dat) != length(group)")
    if(!is.null(names(group)) && !all(names(group) == indID))
        stop("names(group) != rownames(dat)")

    if(!corr_was_presubset) {
        if(ncol(dat) != nrow(corr) || ncol(dat) != ncol(corr))
            stop("corr matrix should be ", ncol(dat), " x ", ncol(dat))

        if(reorder) {
            ord <- stats::hclust(stats::dist(corr), method="average")$order
            variables <- variables[ord]
            dat <- dat[,ord]

            # fanciness to deal with the rows and cols args
            reconstructColumnSelection <-
            function(ord, cols)
            {
                cols.logical <- rep(FALSE, length(ord))
                cols.logical[cols] <- TRUE
                which(cols.logical[ord])
            }
            rows <- reconstructColumnSelection(ord, rows)
            cols <- reconstructColumnSelection(ord, cols)

            # reorder the rows and columns of corr to match
            corr <- corr[ord,ord]
        }

        corr <- corr[rows,cols]
    }

    # get rid of names
    dimnames(corr) <- dimnames(dat) <- NULL
    names(group) <- NULL

    if(scatterplots)
      output <- list(indID = indID,
                     var = variables,
                     corr = corr,
                     rows = rows-1,
                     cols = cols-1,
                     dat =  t(dat), # columns as rows
                     group = group,
                     scatterplots=scatterplots)
    else
      output <- list(indID = indID,
                     var = variables,
                     corr = corr,
                     rows = rows-1,
                     cols = cols-1,
                     scatterplots=scatterplots)
    output
}
