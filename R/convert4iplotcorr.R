## convert4iplotcorr
## Karl W Broman

# Convert data to JSON format for iplotCorr vis
#
# @param dat Data matrix (individuals x variables)
# @param group Optional vector of groups of individuals (e.g., a genotype)
# @param rows Rows of correlation matrix to keep in image
# @param cols Columns of correlation matrix to keep in image
# @param reorder If TRUE, reorder the variables by clustering
# @param corr Correlation matrix
# @param digits Number of digits in JSON; passed to \code{\link[jsonlite]{toJSON}}
#
# @return Character string with the input data in JSON format
#
#' @importFrom jsonlite toJSON
#' @importFrom stats hclust
#
# @keywords interface
# @seealso \code{\link{iplotCorr}}
#
# @examples
# data(geneExpr)
# geneExpr_as_json <- convert4iplotcorr(geneExpr$expr, geneExpr$genotype,
#                                       rows=1:ncol(geneExpr$expr), cols=1:ncol(geneExpr$expr),
#                                       corr=cor(geneExpr$expr, use="pair"))
convert4iplotcorr <-
function(dat, group, rows, cols, reorder=FALSE, corr, corr_was_presubset=FALSE,
         digits=4)
{
  indID <- rownames(dat)
  if(is.null(indID)) indID <- paste(1:nrow(dat))

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
      ord <- hclust(dist(corr), method="average")$order
      variables <- variables[ord]
      dat <- dat[,ord]

      # fanciness to deal with the rows and cols args
      reconstructColumnSelection <- function(ord, cols)
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

  output <- list("indID" = toJSON(indID, na="null"),
                 "var" = toJSON(variables, na="null"),
                 "corr" = toJSON(corr[rows,cols], digits=digits, na="null"),
                 "rows" = toJSON(rows-1, na="null"),
                 "cols" = toJSON(cols-1, na="null"),
                 "dat" =  toJSON(t(dat), digits=digits, na="null"), # columns as rows
                 "group" = toJSON(group, na="null"))
  output <- paste0("{", paste0("\"", names(output), "\" :", output, collapse=","), "}")
  strip_whitespace(output)
}
