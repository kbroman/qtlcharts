#' Arabidopsis QTL data on gravitropism
#'
#' Data from a QTL experiment on gravitropism in
#' Arabidopsis, with data on 162 recombinant inbred lines (Ler x
#' Cvi). The outcome is the root tip angle (in degrees) at two-minute
#' increments over eight hours.
#'
#' @name grav
#' @docType data
#'
#' @usage data(grav)
#'
#' @format An object of class \code{"cross"}; see \code{\link[qtl]{read.cross}}.
#'
#' @keywords datasets
#'
#' @references Moore CR, Johnson LS, Kwak I-Y, Livny M, Broman KW,
#' Spalding EP (2013) High-throughput computer vision introduces the
#' time axis to a quantitative trait map of a plant growth
#' response. Genetics 195:1077-1086
#' (\href{http://www.ncbi.nlm.nih.gov/pubmed/23979570}{PubMed})
#'
#' @source \href{http://qtlarchive.org/db/q?pg=projdetails&proj=moore_2013b}{QTL Archive}
#'
#' @examples
#' data(grav)
#' times <- attr(grav, "time")
#' phe <- grav$pheno
#' \donttest{
#' # open an interactive plot in web browser
#' iplotCurves(phe, times, phe[,c(61,121)], phe[,c(121,181)],
#'             title="gravitropism curves",
#'             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Root tip angle (degrees)",
#'                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
#'                            scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"))}
#' \dontshow{
#' # save plot to temporary html file but don't open
#' iplotCurves(phe, times, phe[,c(61,121)], phe[,c(121,181)],
#'             title="gravitropism curves",
#'             chartOpts=list(curves_xlab="Time (hours)", curves_ylab="Root tip angle (degrees)",
#'                            scat1_xlab="Angle at 2 hrs", scat1_ylab="Angle at 4 hrs",
#'                            scat2_xlab="Angle at 4 hrs", scat2_ylab="Angle at 6 hrs"),
#'             openfile=FALSE)}
NULL
