#' Anonymized gene expression data
#'
#' An anonymized set of gene expression values, for 100
#' genes all influenced by a common locus, plus a vector of genotypes
#' for the 491 individuals.
#'
#' @docType data
#'
#' @usage data(geneExpr)
#'
#' @format A list containing a matrix \code{expr} with the gene
#' expression data plus a vector \code{genotype} with the genotypes.
#'
#' @author Karl W Broman, 2013-05-16
#'
#' @keywords datasets
#'
#' @examples
#' data(geneExpr)
#' \donttest{
#' # open an interactive plot in web browser
#' iplotCorr(geneExpr$expr, geneExpr$genotype, reorder=TRUE,
#'           title="geneExpr correlations linked to scatterplots")}
#' \dontshow{
#' # save to temporary file but don't open
#' iplotCorr(geneExpr$expr, geneExpr$genotype, reorder=TRUE,
#'           title="geneExpr correlations linked to scatterplots",
#'           openfile=FALSE)}
"geneExpr"
