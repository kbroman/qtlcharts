# corr_w_scatter
# Karl W Broman

#' Image of correlation matrix with linked scatterplot
#
#' @param dat Data matrix (individuals x variables)
#' @param group Option vector of groups of individuals (e.g., a genotype)
#' @param reorder If TRUE, reorder the variables by clustering
#' @param corr Correlation matrix (optional)
#' @param file Optional character vector with file to contain the output
#' @param onefile If TRUE, have output file contain all necessary javascript/css code
#' @param openfile If TRUE, open the plot in the default web browser
#' @param title Character string with title for plot
#' @return Character string with the name of the file created
#' @export
#' @examples
#' \dontrun{
#' data(geneExpr)
#' corr_w_scatter(geneExpr$expr, geneExpr$genotype)
#' }

corr_w_scatter <-
function(dat, group, reorder=TRUE, corr=cor(dat, use="pairwise.complete.obs"),
         file, onefile=FALSE, openfile=TRUE, title="Correlation matrix with linked scatterplot")
{
  if(missing(file))
    file <- tempfile(tmpdir=tempdir(), fileext='.html')

  if(onefile)
    warning("The onefile argument hasn't been implemented yet.")
    
  if(file.exists(file))
    stop('The file already exists; please remove it first: ', file)

  if(missing(group)) group <- rep(1, nrow(dat))

  json <- convert4corrwscatter(dat, group, reorder, corr)                                   

  # start writing
  write_html_top(file, title=title)

  append_html_csslink(file, system.file('charts', 'corr_w_scatter.css', package='qtlcharts'))
  append_html_jslink(file, system.file('d3', 'd3.min.js', package='qtlcharts'), 'utf-8')
  append_html_jslink(file, system.file('charts', 'corr_w_scatter.js', package='qtlcharts'))

  append_html_middle(file, title, 'chart')

  append_html_p(file, 'The left panel is an image of a correlation matrix, with blue = -1 and red = +1. ',
                'Hover over pixels in the correlation matrix on the left to see the ',
                'values; click to see the corresponding scatterplot on the right.',
                tag="div", class="legend", id="legend", style="opacity:0;")

  append_html_jscode(file, 'data = ', json, ';\n\n', 'corr_w_scatter(data);')

  append_html_bottom(file)

  if(openfile) browseURL(file)

  invisible(file)
}


