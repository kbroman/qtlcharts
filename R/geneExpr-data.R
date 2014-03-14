#' @name geneExpr
#' @title Anonymized gene expression data
#'
#' @description An anonymized set of gene expression values, for 100
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
#' \dontrun{
#' data(geneExpr)
#' corr_w_scatter(geneExpr$expr, geneExpr$genotype)
#' }
NULL
