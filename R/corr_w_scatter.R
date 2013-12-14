# corr_w_scatter
# Karl W Broman

#' Image of correlation matrix with linked scatterplot
#'
#' Creates an interactive graph with an image of a
#' correlation matrix linked to underlying scatterplots.
#'
#' @param dat Data matrix (individuals x variables)
#' @param group Option vector of groups of individuals (e.g., a genotype)
#' @param rows Selected rows of the correlation matrix to include in the image.
#' @param cols Selected columns of the correlation matrix to include in the image.
#' @param reorder If TRUE, reorder the variables by clustering
#' @param corr Correlation matrix (optional)
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param legend Character vector with text for a legend (to be
#' combined to one string with \code{\link[base]{paste}}, with
#' \code{collapse=''})
#' @return Character string with the name of the file created.
#' @export
#' @examples
#' data(geneExpr)
#' corr_w_scatter(geneExpr$expr, geneExpr$genotype)
corr_w_scatter <-
function(dat, group, rows, cols, reorder=TRUE, corr=cor(dat, use="pairwise.complete.obs"),
         file, onefile=FALSE, openfile=TRUE, title="Correlation matrix with linked scatterplot",
         legend)
{
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(missing(group)) group <- rep(1, nrow(dat))

  if(missing(rows)) rows <- (1:ncol(dat))
  else rows <- selectMatrixColumns(dat, rows)
  if(missing(cols)) cols <- (1:ncol(dat))
  else cols <- selectMatrixColumns(dat, cols)

  json <- convert4corrwscatter(dat, group, rows, cols, reorder, corr)

  # start writing
  write_html_top(file, title=title)


  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_chart('corr_w_scatter', file, onefile=onefile)
  link_chart('iplotPXG', file, onefile=onefile)

  append_html_middle(file, title, 'chart')

  if(missing(legend))
    legend <- c('The left panel is an image of a correlation matrix, with blue = -1 and red = +1. ',
                'Hover over pixels in the correlation matrix on the left to see the ',
                'values; click to see the corresponding scatterplot on the right.')
  append_legend(legend, file)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_jscode(file, 'corr_w_scatter(data);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}


# turn a selection of matrix columns into a numeric vector
# matrix
# cols
selectMatrixColumns <-
function(matrix, cols)
{
  origcols <- cols
  if(is.character(cols)) {
    cols <- match(cols, colnames(matrix))
    if(any(is.na(cols)))
      stop("Unmatched columns: ", paste(origcols[is.na(cols)], collapse=" "))
  }
  (1:ncol(matrix))[cols]
}
