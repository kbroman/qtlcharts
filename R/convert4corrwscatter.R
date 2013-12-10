# convert4corrwscatter
# Karl W Broman

# Convert data to JSON format for corr_w_scatter vis
#
# @param dat Data matrix (individuals x variables)
# @param group Option vector of groups of individuals (e.g., a genotype)
# @param reorder If TRUE, reorder the variables by clustering
# @param corr Correlation matrix
# @return Character string with the input data in JSON format
# @seealso \code{\link{corr_w_scatter}}
# @keywords interface
# @examples
# \dontrun{
# data(geneExpr)
# geneExpr_as_json <- convert4corrwscatter(geneExpr$expr, geneExpr$genotype)
# }
convert4corrwscatter <-
function(dat, group, reorder=TRUE, corr)
{
  ind <- rownames(dat)
  if(is.null(ind)) ind <- paste0("ind", 1:nrow(dat))

  variables <- colnames(dat)
  if(is.null(variables)) variable <- paste0("var", 1:ncol(dat))

  if(missing(group)) group <- rep(1, nrow(dat))

  if(nrow(dat) != length(group))
    stop("nrow(dat) != length(group)")
  if(!is.null(names(group)) && !all(names(group) == ind))
    stop("names(group) != rownames(dat)")

  if(ncol(dat) != nrow(corr) || ncol(dat) != ncol(corr))
    stop("corr matrix should be ", ncol(dat), " x ", ncol(dat))

  if(reorder) {
    ord <- hclust(dist(corr), method="ward")$order
    variables <- variables[ord]
    dat <- dat[,ord]

    # reorder the rows and columns of corr to match
    for(i in 1:nrow(corr))
      corr[i,] <- corr[i,ord]
    for(i in 1:ncol(corr))
      corr[,i] <- corr[ord,i]
  }

  # get rid of names
  dimnames(corr) <- dimnames(dat) <- NULL
  names(group) <- NULL

  output <- list("ind" = toJSON(ind),
                 "var" = toJSON(variables),
                 "corr" = toJSON(corr),
                 "dat" =  toJSON(t(dat)), # columns as rows
                 "group" = toJSON(group))
  paste0("{", paste0("\"", names(output), "\" :", output, collapse=","), "}")
}
