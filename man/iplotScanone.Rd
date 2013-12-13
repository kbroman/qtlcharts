\name{iplotScanone}
\alias{iplotScanone}
\title{Interactive LOD curve}
\usage{
iplotScanone(scanoneOutput, cross, lodcolumn = 1, pheno.col = 1, chr, file,
  onefile = FALSE, openfile = TRUE, title = "", legend,
  fillgenoArgs = NULL, ...)
}
\arguments{
  \item{scanoneOutput}{Object of class \code{"scanone"}, as
  output from \code{\link[qtl]{scanone}}.}

  \item{cross}{(Optional) Object of class \code{"cross"},
  see \code{\link[qtl]{read.cross}}.}

  \item{lodcolumn}{Numeric value indicating LOD score
  column to plot.}

  \item{pheno.col}{(Optional) Phenotype column in cross
  object.}

  \item{chr}{(Optional) Optional vector indicating the
  chromosomes for which LOD scores should be calculated.
  This should be a vector of character strings referring to
  chromosomes by name; numeric values are converted to
  strings. Refer to chromosomes with a preceding - to have
  all chromosomes but those considered. A logical
  (TRUE/FALSE) vector may also be used.}

  \item{file}{Optional character vector with file to
  contain the output}

  \item{onefile}{If TRUE, have output file contain all
  necessary javascript/css code}

  \item{openfile}{If TRUE, open the plot in the default web
  browser}

  \item{title}{Character string with title for plot}

  \item{legend}{Character vector with text for a legend (to
  be combined to one string with \code{\link[base]{paste}},
  with \code{collapse=''})}

  \item{fillgenoArgs}{List of named arguments to pass to
  \code{\link[qtl]{fill.geno}}, if needed.}

  \item{\dots}{Additional arguments passed to the
  \code{\link[RJSONIO]{toJSON}} function}
}
\value{
Character string with the name of the file created.
}
\description{
Creates an interactive graph of a single-QTL genome scan,
as calculated by \code{\link[qtl]{scanone}}. If
\code{cross} is provided, the LOD curves are linked to a
phenotype x genotype plot for a marker: Click on a marker
on the LOD curve and see the corresponding phenotype x
genotype plot.
}
\details{
If \code{cross} is provided, \code{\link[qtl]{fill.geno}}
is used to impute missing genotypes. In this case,
arguments to \code{\link[qtl]{fill.geno}} are passed as a
list, for example \code{fillgenoArgs=list(method="argmax",
error.prob=0.002, map.function="c-f")}.
}
\examples{
data(hyper)
hyper <- calc.genoprob(hyper, step=1)
out <- scanone(hyper)
iplotScanone(out, hyper, chr=c(1, 4, 6, 7, 15))
}
\seealso{
\code{\link{iplotPXG}}
}

