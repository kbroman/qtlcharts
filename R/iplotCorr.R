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
#'   the image. Ignored if \code{corr} is provided.
#' @param cols Selected columns of the correlation matrix to include
#'   in the image. Ignored if \code{corr} is provided.
#' @param reorder If TRUE, reorder the variables by
#'   clustering. Ignored if \code{corr} is provided as a subset of the
#'   overall correlation matrix
#' @param corr Correlation matrix (optional).
#' @param file Optional character vector with file to contain the
#'   output
#' @param onefile If TRUE, have output file contain all necessary
#'   javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @param caption Character vector with text for a caption (to be
#'   combined to one string with \code{\link[base]{paste}}, with
#'   \code{collapse=''})
#' @param chartOpts A list of options for configuring the chart (see
#'   the coffeescript code). Each element must be named using the
#'   corresponding option.
#'
#' @return Character string with the name of the file created.
#'
#' @details \code{corr} may be provided as a subset of the overall
#' correlation matrix for the columns of \code{mat}. In this case, the
#' \code{reorder}, \code{rows} and \code{cols} arguments are ignored. The row and
#' column names of \code{corr} must match the names of some subset of
#' columns of \code{mat}.
#'
#' Individual IDs are taken from \code{rownames(mat)}; they must match
#' \code{names(group)}.
#'
#' @keywords hplot
#' @seealso \code{\link{iheatmap}}, \code{\link{iplotCurves}}
#' 
#' @examples
#' data(geneExpr)
#' iplotCorr(geneExpr$expr, geneExpr$genotype,
#'                title = "iplotCorr example",
#'                chartOpts=list(cortitle="Correlation matrix",
#'                               scattitle="Scatterplot"))
#' @export
iplotCorr <-
function(mat, group, rows, cols, reorder=FALSE, corr=cor(mat, use="pairwise.complete.obs"),
         file, onefile=FALSE, openfile=TRUE, title="Correlation matrix with linked scatterplot",
         caption, chartOpts=NULL)
{
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')
  else file <- path.expand(file)

  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(missing(group)) group <- rep(1, nrow(mat))

  if(!missing(corr)) {
    if(!missing(rows) || !missing(cols)) warning("rows and cols ignored.")
    dn <- dimnames(corr)
    if(any(is.na(match(c(dn[[1]], dn[[2]]), colnames(mat)))))
      stop("Mismatch between dimnames(corr) and colnames(mat).")
    rows <- 1:nrow(corr)
    cols <- 1:ncol(corr)
    reorder <- FALSE
    corr_was_presubset <- TRUE
  }
  else {    
    if(missing(rows)) rows <- (1:ncol(mat))
    else rows <- selectMatrixColumns(mat, rows)
    if(missing(cols)) cols <- (1:ncol(mat))
    else cols <- selectMatrixColumns(mat, cols)
    corr_was_presubset <- FALSE
  }
 
  json <- convert4iplotcorr(mat, group, rows, cols, reorder, corr, corr_was_presubset)

  # start writing
  write_html_top(file, title=title)


  link_d3(file, onefile=onefile)
  link_d3tip(file, onefile=onefile)
  link_panelutil(file, onefile=onefile)
  link_chart('iplotCorr', file, onefile=onefile)

  append_html_middle(file, title, 'chart')

  if(missing(caption))
    caption <- c('The left panel is an image of a correlation matrix, with blue = -1 and red = +1. ',
                'Hover over pixels in the correlation matrix on the left to see the ',
                'values; click to see the corresponding scatterplot on the right.')
  append_caption(caption, file)

  append_html_jscode(file, 'data = ', json, ';')
  append_html_chartopts(file, chartOpts)
  append_html_jscode(file, 'iplotCorr(data, chartOpts);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}
